module Api
  module V1
    class BidsController < MainController
      before_action :authorize_request
      include ApplicationHelper
      include ActionView::Helpers::NumberHelper
      def create
        result = AuthorizePaymentsService.new(params[:payment][:card_token], params[:bid][:internet_transaction_fee]).call
        if result.status == "succeeded"
          @property = Property.find_by(id: params[:property][:id])
          if @property
            if @property.owner_id == @current_user.id
              render json: {property: PropertySerializer.new(@property), message: "Can not submit proposal on own property.", status: 400 }, status: 200 and return
            else
              hightest_bid_offer = @property.highest_bid
              if @property.auction_bidding_ending_at > Time.now
                if params[:bid][:amount].to_f > hightest_bid_offer.to_f
                  @bid = @property.bids.where(user_id: @current_user.id).first_or_create
                  @bid.user_id = @current_user.id
                  @bid.amount = params[:bid][:amount]
                  @bid.buy_option = buy_option_permitter
                  @bid.save
                  if !@bid.offer_detail
                    @offer_detail = @bid.build_offer_detail(offer_detail_params)
                  else
                    @offer_detail = @bid.offer_detail
                    @offer_detail.update(offer_detail_params)
                  end
                  @offer_detail.save
                  if !(params[:bid][:business_documents].blank?)
                    @offer_detail.business_documents.destroy_all
                    params[:bid][:business_documents].each do |document|
                      @offer_detail.business_documents.create(file: document)
                    end
                  end
                  CreateActivityService.new(@bid, "bid_submission").process!
                  if (@property.auction_bidding_ending_at - Time.now < 1.minutes) #time check for bidding time
                    @property.sniper = true
                    @property.sniper_length += 3 #count of time duration increasing in minutes
                    @property.save
                    post_auction(@property)
                    @property.save
                  end
                  Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyBidNotificationWorker, @property.id, @bid.id)
                  if params[:bid][:fund_proof].blank? == false
                    @bid.fund_proofs.destroy_all
                    @bid.fund_proofs.create(file: params[:bid][:fund_proof])
                  end
                  #creating chatrooms
                  @chat_room = @current_user.chat_rooms.where(property_id: @property.id, offer: @bid).first
                  unless @chat_room
                    @chat_room = @current_user.chat_rooms.new(property_id: @property.id)
                    @chat_room.name = @property.address
                    @chat_room.offer = @bid
                    @chat_room.open_connection = false
                    @chat_room.save
                    @chat_room.users << @property.owner
                    @chat_room.users << @current_user
                  end
                  message = @chat_room.messages.new
                  message.content = "I have submitted Bid in your property at #{@property.address} for #{number_to_currency(@bid.amount)} and check proof of funds."
                  message.user_id = @current_user.id
                  message.save
                  if params[:bid][:fund_proof].blank? == false
                    message.attachments.create(file: params[:bid][:fund_proof])
                  end
                  #end
                  render json: {property: PropertySerializer.new(@property), message: "Bid Created.", status: 201 }, status: 200
                else
                  render json: {message: "This amount is less than last Submitted bid.", status: 404 }, status: 200
                end
              else
                render json: {message: "Auction time period is over.", status: 404 }, status: 200
              end
            end
          else
            render json: {message: "Property Not Found.", status: 404}, status: 200
          end
        else
          render json: {message: "Payment not authorized", status: 404}, status: 200
        end
      end
      private
      def offer_detail_params
        params.require(:bid).permit(:user_first_name, :user_middle_name, :user_last_name, :user_email, :user_phone_no, :self_buy_property, :realtor_first_name, :realtor_last_name, :realtor_license, :realtor_company, :realtor_phone_no, :realtor_email, :purchase_property_as, :internet_transaction_fee, :total_due, :promo_code, :property_closing_date, :hold_bid_days, :business_document_text)
      end
      def buy_option_permitter
        JSON.parse(params[:bid][:buy_option])
      end
    end
  end
end
