module Api
  module V1
    class PropertiesController < MainController
      before_action :authorize_request, except: [:new, :register, :public_index, :show]
      before_action :get_user, only: [:show]
      prepend_before_action :current_user, only: [:update]

      def public_index
        params[:page] ||= 1
        if params[:status].blank? == true
          @properties = Property.where.not(status: ["Draft", "Terminated"]).order(created_at: :desc).limit(4)
          render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertySerializer), status: 200 }, status: 200
        else
          if params[:search_str].blank? == false
            @properties = Property.where(status: params[:status]).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = Property.where(status: params[:status]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
          render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: PropertySerializer), status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }, status: 200
        end
      end

      def list_favourites_properties
        if params[:search_str].blank? == false
          @properties = @current_user.watch_properties.where("lower(address) LIKE :search OR lower(headliner) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        else
          @properties = @current_user.watch_properties.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
        end
        render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UserPropertySerializer), status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
      end

      def index
        show_chat = false
        if params[:type] == "offer"
          if params[:search_str].blank? == false
            @properties = @current_user.best_offered_properties.where("lower(address) LIKE :search OR lower(headliner) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = @current_user.best_offered_properties.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
        elsif params[:type] == "bid"
          if params[:search_str].blank? == false
            @properties = @current_user.bidded_properties.where("lower(address) LIKE :search OR lower(headliner) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = @current_user.bidded_properties.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
        elsif params[:type] == "buy_now"
          if params[:search_str].blank? == false
            @properties = @current_user.buy_now_offered_properties.where("lower(address) LIKE :search OR lower(headliner) LIKE :search", search: "%#{params[:search_str].downcase}%").select("DISTINCT ON (properties.id) properties.*").paginate(page: params[:page], per_page: 10)
          else
            @properties = @current_user.buy_now_offered_properties.select("DISTINCT ON (properties.id) properties.*").paginate(page: params[:page], per_page: 10)
            # @properties = Property.includes(:buy_now_offers).where(buy_now_offers: {user: @current_user}).paginate(page: params[:page], per_page: 10)
          end
        else
          show_chat = true
          if params[:search_str].blank? == false
            @properties = @current_user.owned_properties.where("lower(address) LIKE :search OR lower(headliner) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          else
            @properties = @current_user.owned_properties.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          end
        end
        render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UserPropertySerializer, serializer_options: {user: @current_user, type: params[:type], chat: show_chat}), status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages}, request_statuses: Property.request_status, termination_reasons: Property.termination_reason, withdraw_reasons: Property.withdraw_reason }
      end

      def request_status
        @property = Property.find_by(id: params[:property][:id])
        if @property
          if (@property.status != "Draft" || @property.status != "Terminated") && ((params[:property][:request_status] != @property.requested_status ) || (@property.requested == false))
            if params[:property][:request_status] == "Withdraw / Draft"
              @property.status = "Under Review"
              @property.requested = true
              Sidekiq::Client.enqueue_to_in("default", Time.now + Property.approve_time_delay , PropertyDraftWorker, @property.id)
            elsif params[:property][:request_status] == "Terminated"
              CreateActivityService.new(@property, "request_for_termination").process!
              Sidekiq::Client.enqueue_to_in("default", Time.now, PropertyStatusRequestNotificationWorker, @property.id, "Terminated")
            end
            @property.requested_status = params[:property][:request_status]
            @property.requested_at = Time.now
            @property.request_reason = params[:property][:request_reason]
            @property.save
            render json: {message: "Requested status saved.", status: 200}, status: 200
          else
            render json: {message: "Request can not be submitted.", status: 400}, status: 200
          end
        else
          render json: {message: "Property not found.", status: 400}, status: 200
        end
      end

      def edit
        if @current_user.is_admin?
          @property = Property.find_by(unique_address: params[:id])
        else
          @property = @current_user.owned_properties.find_by(unique_address: params[:id])
        end
        @seller_pay_types = SellerPayType.all.order(:created_at)
        @show_instructions_types = ShowInstructionsType.all.order(:created_at)
        if @property
          render json: {property: PropertySerializer.new(@property), seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), categories: Property.category, residential_types: Property.residential_type, commercial_types: Property.commercial_type, land_types: Property.land_type, deal_analysis_types: Property.deal_analysis_type, auction_lengths: Property.auction_length, best_offer_lengths: Property.best_offer_length, buy_options: Property.buy_option, owner_categories: Property.owner_category, title_statuses: Property.title_status, is_admin: @current_user.is_admin , status: 200 }, status: 200
        else
          render json: {message: "This property does not exists", status: 404 }, status: 200
        end
      end

      def submit_for_review
        if @current_user.is_admin?
          @property = Property.find_by(id: params[:property][:id])
        else
          @property = @current_user.owned_properties.find_by(id: params[:property][:id])
        end
        if @property
          @property.status = "Under Review"
          @property.submitted_at = Time.now
          if @property.save
            CreateActivityService.new(@property, "property_posted").process!
            Sidekiq::Client.enqueue_to_in("default", Time.now + Property.approve_time_delay, PropertyApproveWorker, @property.id)
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
        @property = Property.find_by(unique_address: params[:id].strip)
        if @property
          @property.total_views += 1
          @property.save
          if @property.lat.blank? == false && @property.long.blank? == false
            @near_properties = Property.where(status: ["Live Online Bidding", "Best Offer"]).near([@property.lat, @property.long], 50000, units: :km).limit(4)
            if @near_properties.length < 4
              @near_properties = Property.where(status: ["Live Online Bidding", "Best Offer"]).where.not(id: @near_properties.ids).order(address: :asc).limit(4-@near_properties.length)
            end
          else
            @near_properties = Property.where(status: ["Live Online Bidding", "Best Offer"]).order(address: :asc).limit(4)
          end
          @seller_pay_types = SellerPayType.all.order(:created_at)
          @show_instructions_types = ShowInstructionsType.all.order(:created_at)

          render json: {user: UserSerializer.new(@current_user, root: false), seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), property: PropertySerializer.new(@property), favourite: check_favourite(@property.id), buy_options: Property.buy_option, hold_bid_days_options: Property.hold_bid_days_options, purchase_property_as_options: Property.purchase_property_as_options, near_properties: ActiveModel::Serializer::CollectionSerializer.new(@near_properties, each_serializer: UnderReviewPropertySerializer), is_premium: @current_user ? ( @current_user.is_admin? ? @current_user.is_admin? : @current_user.is_premium?) : "", submitted: @property.submitted, is_admin: @current_user ? @current_user.is_admin? : false, status: 200 }, status: 200
        else
          render json: {message: "This property does not exists", status: 404 }, status: 200
        end
      end

      def new
        @seller_pay_types = SellerPayType.all.order(:created_at)
        @show_instructions_types = ShowInstructionsType.all.order(:created_at)
        render json: {seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), categories: Property.category, residential_types: Property.residential_type, commercial_types: Property.commercial_type, land_types: Property.land_type, deal_analysis_types: Property.deal_analysis_type, auction_lengths: Property.auction_length, best_offer_lengths: Property.best_offer_length, buy_options: Property.buy_option, owner_categories: Property.owner_category, title_statuses: Property.title_status, status: 200}, status: 200
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
        else
          if @current_user.is_admin? == false
            if @property.status == "Draft"
              result = PropertyUpdateService.new(@property, params, @current_user).user_process!
            else
              result = PropertyUpdateService.new(@property, params, @current_user).user_property_log_process!
            end
          else
            result = PropertyUpdateService.new(@property, params, @current_user).admin_process!
          end
        end
        if result.status == "success"
          render json: {property: PropertySerializer.new(@property), message: "Property updated sucessfully.", is_admin: @current_user.is_admin, status: 200}, status: 200
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
              CreateActivityService.new(@user, "user_register").process!
              token = JsonWebToken.encode(user_id: @user.id)
              @user.status = "Free"
              @user.trial_ending_at = Time.now.beginning_of_day + 60.days
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
              CreateActivityService.new(@user, "user_login").process!
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
          @property.save
          result = PropertyUpdateService.new(@property, params, @user).user_process!
          if result.status == "success"
            render json: {property: PropertySerializer.new(@property), user_token: @user.auth_token, user: UserSerializer.new(@user, root: false, serializer_options: {token: @user.auth_token}), message: "Property added sucessfully.", status: 201}, status: 200
          else
            render json: {message: "Property could not be added.", status: 400}, status: 200
          end
        end
      end
      def add_watch_properties
        if params[:property_id].blank? == false
          watch_property = @current_user.user_watch_properties.where(property_id: params[:property_id]).first
          if watch_property
            watch_property.destroy
            render json: {message: "Property removed from watch list.", status: 202 }, status: 200
          else
            watch_property = @current_user.user_watch_properties.create(property_id: params[:property_id])
            render json: {message: "Property added to watch list.", status: 201 }, status: 200
          end
        else
          render json: {message: "Please provide property.", status: 400 }, status: 200
        end
      end

      def share
        if params[:property][:email].blank? == false
          Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyShareLinkWorker, params[:property][:email], params[:property][:id], params[:property][:link])
          render json: {message: "Property shared.", status: 200 }, status: 200
        else
          render json: {message: "Email can not be blank.", status: 400 }, status: 200
        end
      end

      def accept_offer
        @property = Property.find_by(id: params[:property_id])
        if @property
          if @property.status == "Sold"
            render json: {message: "Property is sold already.", status: 400}, status: 200 and return
          end
          if params[:offer_type] == "Bid"
            @offer = @property.bids.find_by(id: params[:offer_id])
          elsif params[:offer_type] == "Best Offer"
            @offer = @property.best_offers.find_by(id: params[:offer_id])
          elsif (params[:offer_type] == "Buy Now" || params[:offer_type] == "Best / Buy Now")
            @offer = @property.buy_now_offers.find_by(id: params[:offer_id])
          end
          if params[:accepted] == "false"
            if @offer.accepted != false
              @offer.accepted = false
              @offer.save
            end
            render json: {accepted: false, message: "Offer rejected.", status: 200}, status: 200
          else
            if @offer.accepted != true
              @offer.accepted = true
              if @offer.chat_room
                @offer.chat_room.update(open_connection: true)
              end
              @offer.save
              Sidekiq::Client.enqueue_to_in("default", Time.now, AcceptOfferNotificationWorker, @property.id, @offer.id, params[:offer_type])
            end
            if (@property.status != "Pending") || (@property.status != "Terminated")
              @property.status = "Pending"
              @property.save
              Sidekiq::Client.enqueue_to_in("default", Time.now, PropertyNotificationWorker, @property.id)
            end
            render json: {accepted: true, chat_room: ChatRoomSerializer.new(@offer.chat_room), message: "Offer accepted.", status: 200}, status: 200
          end
        else
          render json: {message: "Property could not be found.", status: 400}, status: 200
        end
      end
      private
      def set_submitted(property)
        property.status = "Under Review"
        if property.submitted == false
          property.submitted_at = Time.now
        end
        property.submitted = true
        property.save
      end
      def check_favourite(property_id)
        if @current_user
          if @current_user.watch_property_ids.include?(property_id)
            true
          else
            false
          end
        else
          false
        end
      end
      def property_params
        params.require(:property).permit(:address, :city, :state, :zip_code, :lat, :long, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :owner_category, :title_status, :additional_information)
      end

      def property_update_params
        params.require(:property).permit(:address, :city, :state, :zip_code, :lat, :long, :category, :p_type, :headliner, :mls_available, :flooded, :flood_count, :description, :owner_category, :additional_information, :seller_price, :buy_now_price, :auction_started_at, :auction_length, :auction_ending_at, :best_offer_auction_started_at, :best_offer_auction_ending_at, :show_instructions_type_id, :seller_pay_type_id, :title_status, :youtube_url, :youtube_video_key, :deal_analysis_type, :after_rehab_value, :asking_price, :estimated_rehab_cost, :profit_potential, :arv_analysis, :description_of_repairs, :vimeo_url, :dropbox_url, :rental_description, :best_offer, :best_offer_length, :best_offer_sellers_minimum_price, :best_offer_sellers_reserve_price, :show_instructions_text)
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
      def configure_sign_up_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :phone_number)
      end
    end
  end
end
