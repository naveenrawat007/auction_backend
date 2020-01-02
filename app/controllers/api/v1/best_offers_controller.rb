module Api
  module V1
    class BestOffersController < MainController
      before_action :authorize_request
      def create
        @property = Property.find_by(id: params[:property][:id])
        if @property
          @best_offer = @property.best_offers.where(user_id: @current_user.id).first_or_create
          @best_offer.user_id = @current_user.id
          @best_offer.amount = params[:best_offer][:amount]
          @best_offer.save
          if params[:best_offer][:fund_proof].blank? == false
            @best_offer.fund_proofs.destroy_all
            @best_offer.fund_proofs.create(file: params[:best_offer][:fund_proof])
          end
          render json: {property: PropertySerializer.new(@property), message: "Best Offer Submitted.", status: 201 }, status: 200
        else
          render json: {message: "Property Not Found.", status: "404"}, status: 200
        end
      end
    end
  end
end