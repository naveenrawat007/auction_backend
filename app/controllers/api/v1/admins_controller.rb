module Api
  module V1
    class AdminsController < MainController
      before_action :authorize_admin_request
      def users_list
        if params[:status].blank? == false
          if params[:search_str].blank? == false
            @users = User.where(status: params[:status]).where("lower(first_name) LIKE :search OR lower(last_name) LIKE :search OR lower(email) LIKE :search OR phone_number LIKE :search ", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @users = User.all.where(status: params[:status]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
        else
          if params[:search_str].blank? == false
            @users = User.where("lower(first_name) LIKE :search OR lower(last_name) LIKE :search OR lower(email) LIKE :search OR phone_number LIKE :search ", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @users = User.all.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
        end
        render json: {users: ActiveModelSerializers::SerializableResource.new(@users, each_serializer: UserSerializer), statuses: User.status, status: 200, meta: {current_page: @users.current_page, total_pages: @users.total_pages} }
      end

      def subscribers_list
        if params[:search_str].blank? == false
          @subscribers = Subscriber.where("lower(name) LIKE :search OR lower(email) LIKE :search OR phone_no::Text LIKE :search ", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        else
          @subscribers = Subscriber.all.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        end
        render json: {subscribers: ActiveModelSerializers::SerializableResource.new(@subscribers, each_serializer: SubscriberSerializer), status: 200, meta: {current_page: @subscribers.current_page, total_pages: @subscribers.total_pages} }
      end


      def update_status
        @user = User.find_by(id: params[:user][:id])
        if @user
          if params[:user][:status].blank? == false
            old_status = @user.status
            @user.status = params[:user][:status]
            @user.save
          end
          render json: {message: "User updated successfully", status: 200}, status: 200
        else
          render json: {message: "User Not found", status: 400}, status: 200
        end
      end

    end
  end
end
