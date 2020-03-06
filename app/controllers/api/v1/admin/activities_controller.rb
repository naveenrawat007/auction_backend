module Api
  module V1
    module Admin
      class ActivitiesController < Api::V1::MainController
        before_action :authorize_admin_request
        def index
          params[:page] ||= 1
          activites = Activity.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          render json: {activities: ActiveModelSerializers::SerializableResource.new(activites, each_serializer: ActivitySerializer), status: 200, meta: {current_page: activites.current_page, total_pages: activites.total_pages}}, status: 200
        end
      end
    end
  end
end
