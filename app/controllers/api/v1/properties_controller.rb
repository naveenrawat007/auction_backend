module Api
  module V1
    class PropertiesController < MainController
      before_action :authorize_request
      def new
        @seller_pay_types = SellerPayType.all.order(:created_at)
        @show_instructions_types = ShowInstructionsType.all.order(:created_at)
        render json: {seller_pay_type: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), status: 200}, status: 200
      end

      def create
        @property = @current_user.owned_properties.new(property_params)
        if @property.save
          if params[:property][:images].blank? == false
            params[:property][:images].each do |image|
              @property.photos.create(image: image)
            end
          end
          render json: {message: "Property added sucessfully.", status: 200}, status: 200
        else
          render json: {message: "Property could not be added.", status: 400}, status: 200
        end
      end

      private
      def property_params
      params.require(:property).permit(:address, :category, :type, :bedrooms, :bathrooms, :garage, :area, :lot_size, :year_built, :units, :price_per_sq_ft, :headliner, :ms_available, :flooded, :flood_count, :estimated_rehab_cost, :description, :seller_price, :buy_now_price, :auction_started_at, :auction_length, :auction_ending_at, :status)
      end
    end
  end
end
