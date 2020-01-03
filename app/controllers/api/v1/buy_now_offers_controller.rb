module Api
  module V1
    class BuyNowOffersController < MainController
      before_action :authorize_request
      def create
        @property = Property.find_by(id: params[:property][:id])
        if @property
          if params[:best_offer] == "true"
            if @property.status == "Approve / Best Offer" && check_best_offer_time
              @buy_now = @property.best_buy_nows.where(user_id: @current_user.id).first_or_create
              @buy_now.user_id = @current_user.id
              @buy_now.amount = params[:buy_now][:amount]
              @buy_now.save
              if params[:buy_now][:fund_proof].blank? == false
                @buy_now.fund_proofs.destroy_all
                @buy_now.fund_proofs.create(file: params[:buy_now][:fund_proof])
              end
              render json: {property: PropertySerializer.new(@property), message: "Offer Created.", status: 201 }, status: 200
            else
              render json: { message: "Can not Submit buy now.", status: 400 }, status: 200
            end
          else
            @buy_now = @property.buy_nows.where(user_id: @current_user.id).first_or_create
            @buy_now.user_id = @current_user.id
            @buy_now.amount = params[:buy_now][:amount]
            @buy_now.save
            if params[:buy_now][:fund_proof].blank? == false
              @buy_now.fund_proofs.destroy_all
              @buy_now.fund_proofs.create(file: params[:buy_now][:fund_proof])
            end
            render json: {property: PropertySerializer.new(@property), message: "Offer Created.", status: 201 }, status: 200
          end
        else
          render json: {message: "Property Not Found.", status: "404"}, status: 200
        end
      end
      private
      def check_best_offer_time
        if @property.best_offer == true
          if (Time.now < @property.auction_started_at + @property.best_offer_length.to_i.days)
            true
          else
            false
          end
        else
          false
        end
      end
    end
  end
end
