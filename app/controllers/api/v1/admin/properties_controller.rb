module Api
  module V1
    module Admin
      class PropertiesController < Admin::MainController
        before_action :authorize_admin_request

        def under_review_properties
          if params[:search_str].blank? == false
            @properties = Property.where(status: "Under Review").where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = Property.where(status: "Under Review").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
          render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertySerializer), status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
        end
      end
    end
  end
end