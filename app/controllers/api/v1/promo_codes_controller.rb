module Api
  module V1
    class PromoCodesController < MainController
      before_action :authorize_request

      def apply_code
        promo_code = @current_user.new(promo_code_params)
        if promo_code.save

        else
          render json: {status: 400, message: "Subscriber not created"}
        end
      end

      private

      def promo_code_params
        params.require(:promo_code).permit(:promo_code)
      end

    end
  end
end
