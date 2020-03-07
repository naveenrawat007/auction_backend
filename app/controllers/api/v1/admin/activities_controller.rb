module Api
  module V1
    module Admin
      class ActivitiesController < Api::V1::MainController
        before_action :authorize_admin_request
        def index
          params[:page] ||= 1
          if params[:type] == "notification"
            activites = Activity.where.not(act_type: ['user_login','user_register','user_password_change','bid_submission','offer_submission']).where(viewed: false).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            activites = Activity.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
          render json: {activities: ActiveModelSerializers::SerializableResource.new(activites, each_serializer: ActivitySerializer), status: 200, meta: {current_page: activites.current_page, total_pages: activites.total_pages}}, status: 200
        end

        def update #wiil mark all notifications read
          activites = Activity.where.not(act_type: ['user_login','user_register','user_password_change','bid_submission','offer_submission']).update_all(viewed: true)
          render json: {message: "Success", status: 200}, status: 200
        end
      end
    end
  end
end
