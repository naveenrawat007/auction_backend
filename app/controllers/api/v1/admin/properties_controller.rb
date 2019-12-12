module Api
  module V1
    module Admin
      class PropertiesController < Api::V1::MainController
        before_action :authorize_admin_request

        def under_review_properties
          if params[:search_str].blank? == false
            @properties = Property.where(status: "Under Review").where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = Property.where(status: "Under Review").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
          render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer), property_statuses: Property.status ,status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
        end

        def best_offers_properties
          if params[:search_str].blank? == false
            @properties = Property.where(status: "Approve / Best Offer").where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = Property.where(status: "Approve / Best Offer").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
          render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer), status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
        end

        def update_status
          @property = Property.find_by(id: params[:property][:id])
          if @property
            if params[:property][:status].blank? == false
              @property.status = params[:property][:status]
              @property.save
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
