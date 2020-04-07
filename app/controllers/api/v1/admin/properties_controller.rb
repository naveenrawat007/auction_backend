module Api
  module V1
    module Admin
      class PropertiesController < Api::V1::MainController
        include ApplicationHelper
        before_action :authorize_admin_request

        def index
          if params[:type] == "termination_request"
            if params[:search_str].blank? == false
              @properties = Property.where(requested_status: "Terminated").where.not(status: "Terminated").where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            else
              @properties = Property.where(requested_status: "Terminated").where.not(status: "Terminated").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            end
            render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer),status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
          else
            if params[:search_str].blank? == false
              if params[:status] == "Under Review"
                @properties = Property.where(status: ["Under Review", "Approve"]).or(Property.where(requested_status: "Withdraw / Draft", requested: true)).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              else
                @properties = Property.where(status: params[:status]).where("lower(address) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              end
            else
              if params[:status] == "Under Review"
                @properties = Property.where(status: ["Under Review", "Approve"]).or(Property.where(requested_status: "Withdraw / Draft", requested: true)).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              else
                @properties = Property.where(status: params[:status]).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
              end
            end
            render json: {properties: ActiveModelSerializers::SerializableResource.new(@properties, each_serializer: UnderReviewPropertySerializer, serializer_options: {status: params[:status]}), property_statuses: Property.status, termination_reason: Property.termination_reason, auction_lengths: Property.auction_length ,status: 200, meta: {current_page: @properties.current_page, total_pages: @properties.total_pages} }
          end
        end

        def update_status
          @property = Property.find_by(id: params[:property][:id])
          if @property
            if params[:property][:status].blank? == false
              old_status = @property.status
              @property.status = params[:property][:status]
              if @property.status == "Terminated"
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyTerminationNotificationWorker, @property.id, @property.bids.map(&:user_id), "Bid")
              elsif @property.status == "Draft"
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyWithdrawnNotificationWorker, @property.id, @property.bids.map(&:user_id), "Bid")
              end
              if @property.requested == true || @property.status == "Terminated"
                @property.bids.destroy_all
                @property.best_offers.destroy_all
                @property.buy_now_offers.destroy_all
              end
              @property.requested = false
              @property.submitted = false
              @property.save
              if @property.status == "Terminated"
                @property.termination_date = Time.now
                @property.termination_reason = params[:property][:termination_reason]
                @property.save
              end
              if old_status != @property.status
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, @property.id)
              end
              if (@property.status == "Approve" || @property.status == "Live Online Bidding")
                if @property.status == "Live Online Bidding"
                  @property.status = "Approve"
                  @property.auction_started_at = params[:property][:auction_started_at]
                  @property.auction_length = params[:property][:auction_length]
                  @property = PropertyTimeService.new(@property).set_property_timing
                  @property.save
                end
                if params[:property][:best_offer] == "true"
                  @property.best_offer = true
                  @property.best_offer_auction_started_at = params[:property][:best_offer_auction_started_at]
                  @property.best_offer_auction_ending_at = params[:property][:best_offer_auction_ending_at]
                  @property = PropertyTimeService.new(@property).set_property_timing
                  @property.save
                end
                  if @property.best_offer == true
                    if @property.best_offer_auction_started_at.blank? == false
                      best_offer_live_auction(@property)
                    end
                    if @property.best_offer_auction_ending_at.blank? == false
                      best_offer_post_auction(@property)
                    end
                  end
                if @property.auction_started_at.blank? == false
                  live_auction(@property)
                  post_auction(@property)
                  @property.save
                else
                  @property.status = "Hold"
                  @property.save
                  Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, @property.id)
                end
              elsif @property.status == "Draft"
                @property.save
              elsif @property.status == "Under Review"
                @property.submitted_at = Time.now
                @property.submitted = true
                @property.save
                Sidekiq::Client.enqueue_to_in("default", Time.now + Property.approve_time_delay, PropertyApproveWorker, @property.id)
              end
            end
            render json: {message: "Property updated successfully", status: 200}, status: 200
          else
            render json: {message: "Property Not found", status: 400}, status: 200
          end
        end

        def sold_property
          if params[:property][:offer_type] == "bid"
            @offer = Bid.find_by(id: params[:property]["offer_id"])
          elsif (params[:property][:offer_type] == "best_buy_now" || params[:property][:offer_type] == "buy_now")
            @offer = BuyNowOffer.find_by(id: params[:property]["offer_id"])
          elsif params[:property][:offer_type] == "best_offer"
            @offer = BestOffer.find_by(id: params[:property]["offer_id"])
          end
          @property = @offer.property
          if !@property.sold_property_record
            sold_property_record = @property.build_sold_property_record
            sold_property_record.property_id = @property.id
            sold_property_record.user_id = @offer.user_id
            sold_property_record.offer = @offer
            sold_property_record.save
            @property.status = "Sold"
            Sidekiq::Client.enqueue_to_in("default", Time.now , PropertySoldNotificationWorker, @property.id)
            @property.save
            render json: {message: "Status changed to Sold", status: 200}, status: 200
          else
            render json: {message: "Property already sold.", status: 400}, status: 200
          end
        end

        def change_log_details
          @property = Property.find_by(id: params[:id])
          if @property
            @seller_pay_types = SellerPayType.all.order(:created_at)
            @show_instructions_types = ShowInstructionsType.all.order(:created_at)
            render json: {seller_pay_types: ActiveModelSerializers::SerializableResource.new(@seller_pay_types, each_serializer: SellerPayTypeSerializer), show_instructions_types: ActiveModelSerializers::SerializableResource.new(@show_instructions_types, each_serializer: SellerPayTypeSerializer), property: PropertySerializer.new(@property), status: 200 }, status: 200
          else
            render json: {message: "This property does not exists", status: 404 }, status: 200
          end
        end
        def change_log_update
          @property = Property.find_by(id: params[:id])
          if @property
            result = PropertyUpdateService.new(@property, params, @current_user).admin_property_change_log_update_process!
            if result.status == "success"
              render json: {property: PropertySerializer.new(@property), message: "Property updated sucessfully.", status: 200}, status: 200
            else
              render json: {property: PropertySerializer.new(@property), message: "Property could not be updated.", status: 400}, status: 200
            end
          else
            render json: {message: "Property not found", status: 404 }, status: 200
          end
        end
      end
    end
  end
end
