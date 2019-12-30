module Api
  module V1
    class BidsController < MainController
      before_action :authorize_request
      def create
        @property = Property.find_by(id: params[:property][:id])
        if @property
          @bid = @property.bids.where(user_id: @current_user.id).first_or_create
          @bid.user_id = @current_user.id
          @bid.amount = params[:bid][:amount]
          @bid.save
          if params[:bid][:fund_proof].blank? == false
            @bid.fund_proofs.destroy_all
            @bid.fund_proofs.create(file: params[:bid][:fund_proof])
          end
          render json: {property: PropertySerializer.new(@property), message: "Bid Created.", status: 201 }, status: 200
        else
          render json: {message: "Property Not Found.", status: "404"}, status: 200
        end
      end
    end
  end
end
