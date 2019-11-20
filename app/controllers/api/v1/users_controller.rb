module Api
  module V1
    class UsersController < MainController
      before_action :authorize_request, except: [:forgot_password]
      def check
        render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}), message: "Authenticated", status: 100}, status: 200
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

      def verify_code
        if params[:verification_code]
          if @current_user.verification_code == params[:verification_code]
            @current_user.is_verified = true
            @current_user.save
            render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}), message: "Email verified successfully.", status: 201}, status: 200
          else
            render json: {user: UserSerializer.new(@current_user, root: false), message: "Could not verify verification code mismatch.", status: 403}, status: 200
          end
        else
          render json: {message: "Please provide verification code", error: "blank code", status: 403}, status: 200
        end
      end

      def resend_verification_code
        ConfirmationSender.send_confirmation_to(@current_user)
        render json: {message: "An email containing verification code is sent successfully.", status: 208}, status: 200
      end
    end
  end
end
