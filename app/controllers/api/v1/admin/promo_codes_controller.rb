module Api
  module V1
    module Admin
      class PromoCodesController < Api::V1::MainController
        include ApplicationHelper
        before_action :authorize_admin_request

        def index
          if params[:status].blank? == false
            if params[:search_str].blank? == false
              @promo_codes = PromoCode.where(availed: ActiveModel::Type::Boolean.new.cast(params[:status])).where('promo_code ilike ?', "%#{params[:search_str]}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            else
              @promo_codes = PromoCode.where(availed: ActiveModel::Type::Boolean.new.cast(params[:status])).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            end
          else
            if params[:search_str].blank? == false
              @promo_codes = PromoCode.where('promo_code ilike ?', "%#{params[:search_str]}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            else
              @promo_codes = PromoCode.all.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            end
          end
          render json: {promo_codes: ActiveModelSerializers::SerializableResource.new(@promo_codes, each_serializer: PromoCodeSerializer), status: 200, meta: {current_page: @promo_codes.current_page, total_pages: @promo_codes.total_pages} }
        end

        def create
          promo_code = PromoCodeService.new(@current_user).admin_generated_code!
          render json: {message: "Promo Code", promo_code: promo_code.promo_code, status: 200}, status: 200
        end

      end
    end
  end
end
