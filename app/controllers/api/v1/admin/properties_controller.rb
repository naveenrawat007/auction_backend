module Api
  module V1
    module Admin
      class PropertiesController < Api::V1::MainController
        include ApplicationHelper
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
              if @property.requested == true
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyTerminationNotificationWorker, @property.id, @property.bids.map(&:user_id), "Bid")
                @property.bids.destroy_all
                @property.best_offers.destroy_all
                @property.buy_now_offers.destroy_all
              end
              @property.requested = false
              @property.submitted = false
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
                      @property.auction_started_at = @property.auction_started_at.beginning_of_day + 8.hours
                      @property.auction_bidding_ending_at = (@property.auction_started_at + @property.auction_length.to_i.days).end_of_day - 4.hours
                    end
                    @property.save
                  end
                  if @property.auction_started_at.blank? == false
                    if @property.best_offer == true
                      if @property.best_offer_auction_started_at.blank? == false
                        best_offer_live_auction(@property)
                      end
                      if @property.best_offer_auction_ending_at.blank? == false
                        best_offer_post_auction(@property)
                      end
                    end
                    live_auction(@property)
                    post_auction(@property)
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
                  @property.submitted = true
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

        def sold_property
          if params[:property][:offer_type] == "Bid"
            @offer = Bid.find_by(id: params[:property]["offer_id"])
          elsif (params[:property][:offer_type] == "Best / Buy Now" || params[:property][:offer_type] == "Buy Now")
            @offer = BuyNowOffer.find_by(id: params[:property]["offer_id"])
          elsif params[:property][:offer_type] == "Best Offer"
            @offer = BestOffer.find_by(id: params[:property]["offer_id"])
          end
          @property = @offer.property
          if !@property.sold_property_record
            sold_property_record = @property.build_sold_property_record
            sold_property_record.property_id = @property.id
            sold_property_record.user_id = @offer.user_id
            sold_property_record.offer = @offer
            sold_property_record.save
            @property.status = "Sold"
            Sidekiq::Client.enqueue_to_in("default", Time.now , PropertySoldNotificationWorker, property.id)
            @property.save
            render json: {message: "Status changed to Sold", status: 200}, status: 200
          else
            render json: {message: "Property already sold.", status: 400}, status: 200
          end
        end
      end
    end
  end
end
