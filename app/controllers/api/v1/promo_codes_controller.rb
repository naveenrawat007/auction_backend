module Api
  module V1
    class PromoCodesController < MainController
      before_action :authorize_request

      def apply_code
        code = PromoCode.find_by(promo_code: params[:promo_code][:promo_code])
        if code
          render json: {status: 200, message: "Promo Code Applied"}
        else
          if !@current_user.promo_code.present?
            render json: {status: 200, message: "Promo Code Applied"}
          else
            render json: {status: 400, message: "Promo Code already applied"}
          end
        end
      end

      private

      def promo_code_params
        params.require(:promo_code).permit(:promo_code)
      end

    end
  end
end
