module Api
  module V1
    class PropertiesController < MainController
      before_action :authorize_request
      def new
        @seller_pay_types = SellerPayType.all.order(:created_at)
        @show_instructions_types = ShowInstructionsType.all.order(:created_at)
        render json: {seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), categories: Property.category, residential_types: Property.residential_type, commercial_types: Property.commercial_type, land_types: Property.land_type, status: 200}, status: 200
      end

      def create
        @property = @current_user.owned_properties.new(property_params)
        if @property.save
          if params[:property][:residential_attributes].blank? == false
            @property.residential_attributes = residential_type_attributes_permitter
            @property.save
          end
          if params[:property][:commercial_attributes].blank? == false
            @property.commercial_attributes = commercial_type_attributes_permitter
            @property.save
          end
          if params[:property][:land_attributes].blank? == false
            @property.land_attributes = land_type_attributes_permitter
            @property.save
          end
          render json: {property: PropertySerializer.new(@property), message: "Property added sucessfully.", status: 200}, status: 200
        else
          render json: {message: "Property could not be added.", status: 400}, status: 200
        end
      end

      def update
        @property = Property.find_by(id: params[:property][:id])
        if @property.update(property_update_params)
          render json: {property: PropertySerializer.new(@property), message: "Property updated sucessfully.", status: 200}, status: 200
        else
          render json: {property: PropertySerializer.new(@property), message: "Property could not be updated.", status: 400}, status: 200
        end
      end
      private
      def property_params
      params.require(:property).permit(:address, :city, :state, :zip_code, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description)
      end

      def property_update_params
        params.require(:property).permit(:address, :city, :state, :zip_code, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description)
      end

      def residential_type_attributes_permitter
        JSON.parse(params[:property][:residential_attributes].to_json)
      end
      def commercial_type_attributes_permitter
        JSON.parse(params[:property][:commercial_attributes].to_json)
      end
      def land_type_attributes_permitter
        JSON.parse(params[:property][:land_attributes].to_json)
      end
    end
  end
end
