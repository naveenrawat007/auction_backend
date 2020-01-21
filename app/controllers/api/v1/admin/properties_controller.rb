module Api
  module V1
    module Admin
      class PropertiesController < Api::V1::MainController
        before_action :authorize_admin_request

        def index
          if params[:type] == "termination_request"
            if params[:search_str].blank? == false
              @properties = Property.where(requested_status: "Terminated").where.not(status: "Terminated").where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            else
              @properties = Property.where(requested_status: "Terminated").where.not(status: "Terminated").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            end
            render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer),status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
          else
            if params[:search_str].blank? == false
              if params[:status] == "Under Review"
                @properties = Property.where(status: ["Under Review", "Approve"]).or(Property.where(requested_status: "Withdraw / Draft", requested: true)).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              else
                @properties = Property.where(status: params[:status]).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              end
            else
              if params[:status] == "Under Review"
                @properties = Property.where(status: ["Under Review", "Approve"]).or(Property.where(requested_status: "Withdraw / Draft", requested: true)).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              else
                @properties = Property.where(status: params[:status]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              end
            end
            render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer), property_statuses: Property.status, termination_reason: Property.termination_reason, auction_lengths: Property.auction_length ,status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
          end
        end

        def update_status
          @property = Property.find_by(id: params[:property][:id])
          if @property
            if params[:property][:status].blank? == false
              old_status = @property.status
              @property.status = params[:property][:status]
              @property.requested = false
              @property.save
              if @property.status == "Terminated"
                @property.termination_date = Time.now
                @property.termination_reason = params[:property][:termination_reason]
                @property.save
              end
              if old_status != @property.status
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, @property.id)
                if (@property.status == "Approve" || @property.status == "Live Online Bidding")
                  if @property.status == "Live Online Bidding"
                    @property.status = "Approve"
                    @property.auction_started_at = params[:property][:auction_started_at]
                    @property.auction_length = params[:property][:auction_length]
                    if @property.auction_started_at.blank? == false
                      @property.auction_started_at = @property.auction_started_at.beginning_of_day
                    end
                    @property.save
                  end
                  if @property.auction_started_at.blank? == false
                    if @property.best_offer == true
                      Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyBestOfferWorker, @property.id)
                      Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at + @property.best_offer_length.to_i.days , PropertyLiveWorker, @property.id)
                    else
                      Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyLiveWorker, @property.id)
                    end
                    post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.bidding_ending_at, PropertyPostAuctionWorker, @property.id)
                    @property.post_auction_worker_jid = post_auction_worker_jid
                    @property.save
                  else
                    @property.status = "Hold"
                    @property.save
                    Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, @property.id)
                  end
                elsif @property.status == "Draft"
                  @property.save
                elsif @property.status == "Under Review"
                  @property.submitted_at = Time.now
                  @property.save
                  Sidekiq::Client.enqueue_to_in("default", Time.now + Property.approve_time_delay, PropertyApproveWorker, @property.id)
                end
              end
            end
            render json: {message: "Property updated successfully", status: 200}, status: 200
          else
            render json: {message: "Property Not found", status: 400}, status: 200
          end
        end
      end
    end
  end
end
