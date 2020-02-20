class Api::V1::Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  respond_to :json
  def create
    @user = User.find_by(email:params[:user][:email])
    if @user
      if @user.status == "Ban"
        render json: {message: "You have been ban to the site pleasse contact support@auctionmydeal.com!", error: "Wrong Password", status: 401}, status: 200 and return
      end
      if @user.valid_password?(params[:user][:password])
        token = JsonWebToken.encode(user_id: @user.id)
        @user.auth_token = token
        @user.save
        render json: {user: UserSerializer.new(@user, root: false, serializer_options: {token: token}), status: 202}, status: 200
      else
        render json: {message: "Wrong password. Could not authenticate!", error: "Wrong Password", status: 401}, status: 200
      end
    else
      render json: {message: "User does not exist with this email.", error: 'User does not exist.', status: 404 }, status: 200
    end
  end
end
