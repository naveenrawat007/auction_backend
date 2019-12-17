module Api
  module V1
    class PropertiesController < MainController
      before_action :authorize_request, except: [:new, :register]

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
          @property.submitted_at = Time.now
          if @property.save
            Sidekiq::Client.enqueue_to_in("default", Time.now + 24.hours, PropertyApproveWorker, @property.id)
            Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyUnderReviewWorker, @current_user.id, @property.id)
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
        render json: {seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), categories: Property.category, residential_types: Property.residential_type, commercial_types: Property.commercial_type, land_types: Property.land_type, deal_analysis_types: Property.deal_analysis_type, auction_lengths: Property.auction_length, buy_options: Property.buy_option, owner_categories: Property.owner_category, title_statuses: Property.title_status, status: 200}, status: 200
      end

      def create
        @property = @current_user.owned_properties.new(property_params)
        @property.status = "Draft"
        if @property.save
          if params[:property][:residential_attributes].blank? == false
            @property.residential_attributes = params[:property][:residential_attributes]
            @property.save
          end
          if params[:property][:commercial_attributes].blank? == false
            @property.commercial_attributes = params[:property][:commercial_attributes]
            @property.save
          end
          if params[:property][:land_attributes].blank? == false
            @property.land_attributes = params[:property][:land_attributes]
            @property.save
          end
          render json: {property: PropertySerializer.new(@property), message: "Property added sucessfully.", status: 200}, status: 200
        else
          render json: {message: "Property could not be added.", status: 400}, status: 200
        end
      end

      def update
        @property = Property.find_by(id: params[:property][:id])
        if !@property
          render json: { message: "Property could not be found.", status: 404}, status: 200 and return
        end
        if @property.update(property_update_params)
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
          if params[:property][:open_house_dates]
            if open_house_dates_permitter.blank? == false
              @property.open_house_dates = open_house_dates_permitter
            end
          end
          if params[:property][:estimated_rehab_cost_attr]
            @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter
          end
          if params[:property][:buy_option]
            @property.buy_option = buy_option_permitter
          end
          if params[:images].blank? == false
            @property.photos.destroy_all
            params[:images].each do |image|
              @property.photos.create(image: image)
            end
          end
          if params[:video].blank? == false
            @property.videos.destroy_all
            @property.videos.create(video: params[:video])
          end
          if params[:arv_proof].blank? == false
            @property.arv_proofs.destroy_all
            @property.arv_proofs.create(file: params[:property][:arv_proof], name: "Arv Proof")
          end
          if params[:rehab_cost_proof].blank? == false
            @property.rehab_cost_proofs.destroy_all
            @property.rehab_cost_proofs.create(file: params[:property][:arv_proof], name: "Rehab Cost Proof")
          end
          if params[:rental_proof].blank? == false
            @property.rental_proofs.destroy_all
            @property.rental_proofs.create(file: params[:property][:arv_proof], name: "Rental Proof")
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
          if params[:draft] == "false"
            if @property.status == "Draft"
              @property.status = "Under Review"
              if @property.save
                @property.submitted_at = Time.now
                @property.save
                Sidekiq::Client.enqueue_to_in("default", Time.now + 24.hours, PropertyApproveWorker, @property.id)
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyUnderReviewWorker, @current_user.id, @property.id)
              end
            end
          end
          render json: {property: PropertySerializer.new(@property), message: "Property updated sucessfully.", status: 200}, status: 200
        else
          render json: {property: PropertySerializer.new(@property), message: "Property could not be updated.", status: 400}, status: 200
        end
      end
      def register
        if params[:submit_type] == "register"
          @old_user = User.find_by(email: params[:user][:email])
          @old_user ||= User.find_by(phone_number: params[:user][:phone_number])
          if !@old_user
            @user = User.new(configure_sign_up_params)
            ConfirmationSender.send_confirmation_to(@user)
            if @user.save
              token = JsonWebToken.encode(user_id: @user.id)
              @user.auth_token = token
              @user.save
            else
              render json: { message: "Can not add user.", error: "User save error", status: 400}, status: 200 and return
            end
          else
            render json: { message: "User already exist with this email or phone number.", error: "User exists", status: 409}, status: 200 and return
          end
        elsif params[:submit_type] == "login"
          @user = User.find_by(email:params[:user][:email])
          if @user
            if @user.valid_password?(params[:user][:password])
              token = JsonWebToken.encode(user_id: @user.id)
              @user.auth_token = token
              @user.save
            else
              render json: {message: "Wrong password. Could not authenticate!", error: "Wrong Password", status: 401}, status: 200 and return
            end
          else
            render json: {message: "User does not exist with this email.", error: 'User does not exist.', status: 404 }, status: 200 and return
          end
        end
        if @user
          @property = @user.owned_properties.new(property_update_params)
          @property.status = "Draft"
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
          @property.estimated_rehab_cost_attr = estimated_rehab_cost_attributes_permitter
          @property.buy_option = buy_option_permitter

          if params[:images].blank? == false
            @property.photos.destroy_all
            params[:images].each do |image|
              @property.photos.create(image: image)
            end
          end
          if params[:video].blank? == false
            @property.videos.destroy_all
            @property.videos.create(video: params[:video])
          end
          if params[:arv_proof].blank? == false
            @property.arv_proofs.destroy_all
            @property.arv_proofs.create(file: params[:property][:arv_proof], name: "Arv Proof")
          end
          if params[:rehab_cost_proof].blank? == false
            @property.rehab_cost_proofs.destroy_all
            @property.rehab_cost_proofs.create(file: params[:property][:arv_proof], name: "Rehab Cost Proof")
          end
          if params[:rental_proof].blank? == false
            @property.rental_proofs.destroy_all
            @property.rental_proofs.create(file: params[:property][:arv_proof], name: "Rental Proof")
          end
          if open_house_dates_permitter.blank? == false
            @property.open_house_dates = open_house_dates_permitter
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
          if @property.save
            render json: {property: PropertySerializer.new(@property), user_token: @user.auth_token, message: "Property added sucessfully.", status: 201}, status: 200
          else
            render json: {message: "Property could not be added.", status: 400}, status: 200
          end
        end
      end
      private
      def property_params
        params.require(:property).permit(:address, :city, :state, :zip_code, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :owner_category, :title_status, :additional_information)
      end

      def property_update_params
        params.require(:property).permit(:address, :city, :state, :zip_code, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :owner_category, :additional_information, :seller_price, :buy_now_price, :auction_started_at, :auction_length, :auction_ending_at, :show_instructions_type_id, :seller_pay_type_id, :title_status, :youtube_url, :deal_analysis_type, :after_rehab_value, :asking_price, :estimated_rehab_cost, :profit_potential, :arv_analysis, :description_of_repairs, :vimeo_url, :dropbox_url, :rental_description, :best_offer, :best_offer_length, :best_offer_sellers_minimum_price, :best_offer_sellers_reserve_price, :show_instructions_text)
      end

      def open_house_dates_permitter
        JSON.parse(params[:property][:open_house_dates])
      end

      def buy_option_permitter
        JSON.parse(params[:property][:buy_option])
      end

      def residential_type_attributes_permitter
        JSON.parse(params[:property][:residential_attributes])
      end
      def commercial_type_attributes_permitter
        JSON.parse(params[:property][:commercial_attributes])
      end
      def land_type_attributes_permitter
        JSON.parse(params[:property][:land_attributes])
      end
      # def estimated_rehab_cost_attributes_permitter2
      #   JSON.parse(params[:property][:estimated_rehab_cost_attr])
      # end
      def estimated_rehab_cost_attributes_permitter
        JSON.parse(params[:property][:estimated_rehab_cost_attr])
      end
      def landlord_deal_params
        params.require(:property).permit(:closing_cost, :short_term_financing_cost, :total_acquisition_cost, :taxes_annually, :insurance_annually, :amount_financed_percentage, :amount_financed, :interest_rate, :loan_terms, :principal_interest, :taxes_monthly, :insurance_monthly, :piti_monthly_debt, :monthly_rent, :total_gross_yearly_income, :vacancy_rate, :adjusted_gross_yearly_income, :est_annual_management_fees, :est_annual_operating_fees, :annual_debt, :net_operating_income, :annual_cash_flow, :monthly_cash_flow, :total_out_of_pocket, :roi_cash_percentage, :est_annual_operating_fees_others)
      end
    end
  end
end
