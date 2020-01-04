module Api
  module V1
    module Admin
      class PropertiesController < Api::V1::MainController
        before_action :authorize_admin_request

        def index
          if params[:search_str].blank? == false
            if params[:status] == "Under Review"
              @properties = Property.where(status: ["Under Review", "Approve"]).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            else
              @properties = Property.where(status: params[:status]).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            end
          else
            if params[:status] == "Under Review"
              @properties = Property.where(status: ["Under Review", "Approve"]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            else
              @properties = Property.where(status: params[:status]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            end
          end
          render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer), property_statuses: Property.status ,status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
        end

        def update_status
          @property = Property.find_by(id: params[:property][:id])
          if @property
            if params[:property][:status].blank? == false
              old_status = @property.status
              @property.status = params[:property][:status]
              @property.save
              if old_status != @property.status
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, @property.id)
                if @property.status == "Approve"
                  if @property.auction_started_at.blank? == false
                    if @property.best_offer == true
                      Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyBestOfferWorker, @property.id)
                      Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at + @property.best_offer_length.to_i.days , PropertyLiveWorker, @property.id)
                    else
                      Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyLiveWorker, @property.id)
                    end
                    Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at + @property.best_offer_length.to_i.days + @property.auction_length.to_i.days , PropertyPostAuctionWorker, @property.id)
                  else
                    @property.status = "Pending"
                    @property.save
                    Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, @property.id)
                  end
                elsif @property.status == "Under Review"
                  @property.submitted_at = Time.now
                  @property.save
                elsif @property.status == "Terminated"
                  @property.termination_date = Time.now
                  @property.save
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
