module Api
  module V1
    class PromoCodesController < MainController
      before_action :authorize_request

      def apply_code
        code = PromoCode.find_by(promo_code: params[:promo_code])
        if code
          if (code.user.id == @current_user.id) || code.user.is_admin
            render json: {status: 200, message: "Promo Code Applied"}, status: 200  and return
          end
        end
        render json: {status: 400, message: "Promo Code is not valid."}, status: 200
      end
      def show
        if @current_user.promo_code
          promo_code = @current_user.promo_code
          if promo_code.availed
            render json: {status: 400, message: "Promo Code already applied"}, status: 200 and return
          end
        else
          promo_code = PromoCodeService.new(@current_user).generated_code!
        end
        render json: {message: "Promo Code", promo_code: promo_code.promo_code, status: 200}, status: 200
      end

      private

      def promo_code_params
        params.require(:promo_code).permit(:promo_code)
      end

    end
  end
end
