class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session
  respond_to :json

  def create
    @old_user = User.find_by(email: params[:user][:email])
    @old_user ||= User.find_by(phone_number: params[:user][:phone_number])
    if !@old_user
      @user = User.new(configure_sign_up_params)
      ConfirmationSender.send_confirmation_to(@user)
      if @user.save
        token = JsonWebToken.encode(user_id: @user.id)
        @user.auth_token = token
        @user.trial_ending_at = Time.now.beginning_of_day + 60.days
        @user.save
        render json: {user: UserSerializer.new(@user, root: false, serializer_options: {token: token}), status: 201}, status: 200
      else
        render json: { message: "Can not add user.", error: "User save error", status: 400}, status: 200
      end
    else
      render json: { message: "User already exist with this email or phone number.", error: "User exists", status: 409}, status: 200
    end
  end

  private
  def configure_sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone_number)
  end
end
