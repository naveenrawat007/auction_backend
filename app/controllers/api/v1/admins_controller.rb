module Api
  module V1
    class AdminsController < MainController
      before_action :authorize_admin_request
      def users_list
        if params[:search_str].blank? == false
          @users = User.where("lower(first_name) LIKE :search OR lower(last_name) LIKE :search OR lower(email) LIKE :search ", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        else
          @users = User.all.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        end
        render json: {users: ActiveModelSerializers::SerializableResource.new(@users, each_serializer: UserSerializer), status: 200, meta: {current_page: @users.current_page, total_pages: @users.total_pages} }
      end
    end
  end
end
