module Api
  module V1
    module Admin
      class PropertiesController < Api::V1::MainController
        before_action :authorize_admin_request

        def index
          if params[:search_str].blank? == false
            @properties = Property.where(status: params[:status]).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = Property.where(status: params[:status]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
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
                if @property.status == "Approve / Best Offer"
                  if @property.auction_started_at.blank? == false
                    Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyLiveWorker, @property.id)
                  end
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
