module Api
  module V1
    class UsersController < MainController
      before_action :authorize_request, except: [:forgot_password]
      def check
        render json: {message: "Authenticated", status: 100}, status: 200
      end
      def forgot_password
        @user = User.find_by(email: params[:email])
        if @user
          Sidekiq::Client.enqueue_to_in("default", Time.now, UserPasswordWorker, @user.id)
          render json: { message: "An Email to reset password is sent to your email.", status: 200}, status: 200
        else
          render json: { message: "No Account Infomation found with this account.", error: "Account not found", status: 404}, status: 200
        end
      end
      def new_password
        @current_user.password = params[:user][:password]
        if @current_user.save
          render json: { message: "Password changed sucessfully. Now you can login.", status: 200}, status: 200
        else
          render json: { message: "Could not change password.", error: "Password error.", status: 400}, status: 200
        end
      end
    end
  end
end
