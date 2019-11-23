module Api
  module V1
    class UsersController < MainController
      before_action :authorize_request, except: [:forgot_password]
      def show
        render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}), status:200}, status:200
      end
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
      def update_profile
        if params[:user][:email].blank? == false || params[:user][:phone].blank? == false
          old_user = User.find_by(email: params[:user][:email])
          old_user ||= User.find_by(email: params[:user][:phone_number])
          if old_user
            if old_user.id == @current_user.id || !old_user
              if @current_user.update(update_params)
                if params[:user][:type_attributes].blank? == false
                  @current_user.type_attributes = type_attributes_permitter
                  @current_user.save
                end
                render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}),message: "Profile updated successfully", status:200} and return
              else
                render json: {message: "Could not update", status: 400} and return
              end
            else
              render json: {message: "Email or Phone number already exist.", status: 406} and return
            end
          else
            if @current_user.update(update_params)
              if params[:user][:type_attributes].blank? == false
                @current_user.type_attributes = type_attributes_permitter
                @current_user.save
              end
              render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}),message: "Profile updated successfully", status:200} and return
            else
              render json: {message: "Could not update", status: 406} and return
            end
          end
        else
          render json: {message: "Email and Phone can't be blank.", status: 406} and return
        end
      end

      private
      def update_params
        params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :company_name, :mobile, :address, :city, :state, :realtor_licence, :broker_licence, :type_attributes)
      end

      def type_attributes_permitter
        JSON.parse(params[:user][:type_attributes].to_json)
      end
    end
  end
end
