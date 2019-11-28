module Api
  module V1
    class MainController < ActionController::API
      respond_to :json
      private
      def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { error: "User not exists", status: 401 }, status: 200
        rescue JWT::DecodeError => e
          render json: { error: e.message, status: 401 }, status: 200
        end
      end
    end
  end
end
