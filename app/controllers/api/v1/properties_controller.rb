module Api
  module V1
    class PropertiesController < MainController
      before_action :authorize_request

      def index
        if params[:search_str].blank? == false
          @properties = @current_user.owned_properties.where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        else
          @properties = @current_user.owned_properties.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        end
        render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertySerializer), status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
      end

      def submit_for_review
        @property = @current_user.owned_properties.find_by(id: params[:property][:id])
        if @property
          @property.status = "Under Review"
          if @property.save
            render json: {property: PropertySerializer.new(@property), message: "Property status updated sucessfully.", status: 200}, status: 200
          else
            render json: {property: PropertySerializer.new(@property), message: "Property could not be updated.", status: 400}, status: 200
          end
        else
          render json: { message: "Property could not be found.", status: 400}, status: 200
        end
      end

      def show
        @property = Property.find_by(id: params[:id])
        if @property
          @property.total_views += 1
          @property.save
          render json: {property: PropertySerializer.new(@property), status: 200 }
        else
          render json: {message: "This property does not exists", status: 404 }
        end
      end

      def new
        @seller_pay_types = SellerPayType.all.order(:created_at)
        @show_instructions_types = ShowInstructionsType.all.order(:created_at)
        render json: {seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), categories: Property.category, residential_types: Property.residential_type, commercial_types: Property.commercial_type, land_types: Property.land_type, deal_analysis_types: Property.deal_analysis_type, auction_lengths: Property.auction_length, buy_options: Property.buy_option, status: 200}, status: 200
      end

      def create
        @property = @current_user.owned_properties.new(property_params)
        @property.status = "Under Review"
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
          # @property.deal_analysis_type = params[:property][:deal_analysis_type]
          # @property.after_rehab_value = params[:property][:after_rehab_value]
          # @property.asking_price = params[:property][:asking_price]
          # @property.estimated_rehab_cost = params[:property][:estimated_rehab_cost]
          # @property.arv_analysis = params[:property][:arv_analysis]
          # @property.description_of_repairs = params[:property][:description_of_repairs]
          if params[:step2].blank? == false
            @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter2
          else
            @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter
            @property.buy_option = buy_option_permitter
          end
          if params[:property][:images].blank? == false
            @property.photos.destroy_all
            params[:property][:images].each do |image|
              @property.photos.create(image: image)
            end
          end
          if params[:property][:arv_proof].blank? == false
            @property.arv_proofs.destroy_all
            @property.arv_proofs.create(file: params[:property][:arv_proof], name: "Arv Proof")
          end
          if params[:property][:rehab_cost_proof].blank? == false
            @property.rehab_cost_proofs.destroy_all
            @property.rehab_cost_proofs.create(file: params[:property][:arv_proof], name: "Rehab Cost Proof")
          end
          @property.save
          if @property.deal_analysis_type == "Rehab & Flip Deal"
            @property.profit_potential = params[:property][:profit_potential]
          elsif @property.deal_analysis_type == "Landlord Deal"
            if @property.landlord_deal
              @landlord_deal = @property.landlord_deal
            else
              @landlord_deal = @property.build_landlord_deal
              @landlord_deal.save
            end
            @landlord_deal.update(landlord_deal_params)
            @landlord_deal.save
          end
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
        params.require(:property).permit(:address, :city, :state, :zip_code, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :seller_price, :buy_now_price, :auction_started_at, :auction_length, :auction_ending_at, :show_instructions_type_id, :seller_pay_type_id, :title_status, :youtube_url, :deal_analysis_type, :after_rehab_value, :asking_price, :estimated_rehab_cost, :profit_potential, :arv_analysis, :description_of_repairs)
      end

      def buy_option_permitter
        JSON.parse(params[:property][:buy_option].to_json)
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
      def estimated_rehab_cost_attributes_permitter2
        JSON.parse(params[:property][:estimated_rehab_cost_attr])
      end
      def estimated_rehab_cost_attributes_permitter
        JSON.parse(params[:property][:estimated_rehab_cost_attr].to_json)
      end
      def landlord_deal_params
        params.require(:property).permit(:closing_cost, :short_term_financing_cost, :total_acquisition_cost, :taxes_annually, :insurance_annually, :amount_financed_percentage, :amount_financed, :interest_rate, :loan_terms, :principal_interest, :taxes_monthly, :insurance_monthly, :piti_monthly_debt, :monthly_rent, :total_gross_yearly_income, :vacancy_rate, :adjusted_gross_yearly_income, :est_annual_management_fees, :est_annual_operating_fees, :annual_debt, :net_operating_income, :annual_cash_flow, :monthly_cash_flow, :total_out_of_pocket, :roi_cash_percentage, :est_annual_operating_fees_others)
      end
    end
  end
end
