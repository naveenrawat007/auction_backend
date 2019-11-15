module Api
  module V1
    class UsersController < MainController
      before_action :authorize_request
      def check
        render json: {message: "Authenticated", status: 100}, status: 200
      end
    end
  end
end
