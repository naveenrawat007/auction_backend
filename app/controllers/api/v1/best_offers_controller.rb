module Api
  module V1
    class BestOffersController < MainController
      before_action :authorize_request
      def create
        @property = Property.find_by(id: params[:property][:id])
        if @property
          if @property.owner_id == @current_user.id
            render json: {property: PropertySerializer.new(@property), message: "Can not submit proposal on own property.", status: 400 }, status: 200 and return
          else
            hightest_best_offer = @property.best_offers.maximum(:amount)
            if params[:best_offer][:amount].to_f > hightest_best_offer
              @best_offer = @property.best_offers.where(user_id: @current_user.id).first_or_create
              @best_offer.user_id = @current_user.id
              @best_offer.amount = params[:best_offer][:amount]
              @best_offer.buy_option = buy_option_permitter
              @best_offer.save
              Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyBestOfferNotificationWorker, @property.id)
              if params[:best_offer][:fund_proof].blank? == false
                @best_offer.fund_proofs.destroy_all
                @best_offer.fund_proofs.create(file: params[:best_offer][:fund_proof])
              end
              render json: {property: PropertySerializer.new(@property), message: "Best Offer Submitted.", status: 201 }, status: 200
            else
              render json: {message: "This amount is less than last Submitted Offer.", status: 400}, status: 200
            end
          end
        else
          render json: {message: "Property Not Found.", status: 404}, status: 200
        end
      end
      private
      def buy_option_permitter
        JSON.parse(params[:best_offer][:buy_option])
      end
    end
  end
end
