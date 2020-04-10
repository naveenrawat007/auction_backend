module Api
  module V1
    class BestOffersController < MainController
      before_action :authorize_request
      include ActionView::Helpers::NumberHelper
      def create
        result = AuthorizePaymentsService.new(params[:payment][:card_token], params[:best_offer][:internet_transaction_fee]).call
        if result.status == "succeeded"
          @property = Property.find_by(id: params[:property][:id])
          if @property
            if @property.owner_id == @current_user.id
              render json: {property: PropertySerializer.new(@property), message: "Can not submit proposal on own property.", status: 400 }, status: 200 and return
            else
              hightest_best_offer = @property.best_offer_price
              if params[:best_offer][:amount].to_f > hightest_best_offer.to_f
                @best_offer = @property.best_offers.where(user_id: @current_user.id).first_or_create
                @best_offer.user_id = @current_user.id
                @best_offer.amount = params[:best_offer][:amount]
                @best_offer.buy_option = buy_option_permitter
                @best_offer.save
                if !@best_offer.offer_detail
                  @offer_detail = @best_offer.build_offer_detail(offer_detail_params)
                else
                  @offer_detail = @best_offer.offer_detail
                  @offer_detail.update(offer_detail_params)
                end
                @offer_detail.save
                if !(params[:best_offer][:business_documents].blank?)
                  @offer_detail.business_documents.destroy_all
                  params[:best_offer][:business_documents].each do |document|
                    @offer_detail.business_documents.create(file: document)
                  end
                end
                CreateActivityService.new(@best_offer, "offer_submission").process!
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyBestOfferNotificationWorker, @property.id)
                Sidekiq::Client.enqueue_to_in("default", Time.now , BuyerBestOfferNotificationWorker, @property.id, @current_user.id)
                if params[:best_offer][:fund_proof].blank? == false
                  @best_offer.fund_proofs.destroy_all
                  @best_offer.fund_proofs.create(file: params[:best_offer][:fund_proof])
                end
                #creating chatrooms
                @chat_room = @current_user.chat_rooms.where(property_id: @property.id, offer: @best_offer).first
                unless @chat_room
                  @chat_room = @current_user.chat_rooms.new(property_id: @property.id)
                  @chat_room.name = @property.address
                  @chat_room.offer = @best_offer
                  @chat_room.save
                  @chat_room.users << @property.owner
                  @chat_room.users << @current_user
                end
                message = @chat_room.messages.new
                message.content = "I have submitted Best Offer in your property at #{@property.address} for #{number_to_currency(@best_offer.amount)} and check proof of funds."
                message.user_id = @current_user.id
                message.save
                if params[:best_offer][:fund_proof].blank? == false
                  message.attachments.create(file: params[:best_offer][:fund_proof])
                end
                #end
                render json: {chat_room: ChatRoomSerializer.new(@chat_room), property: PropertySerializer.new(@property), message: "Best Offer Submitted.", status: 201 }, status: 200
              else
                render json: {message: "This amount is less than last Submitted Offer.", status: 400}, status: 200
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
      def buy_option_permitter
        JSON.parse(params[:best_offer][:buy_option])
      end
      def offer_detail_params
        params.require(:best_offer).permit(:user_first_name, :user_middle_name, :user_last_name, :user_email, :user_phone_no, :self_buy_property, :realtor_first_name, :realtor_last_name, :realtor_license, :realtor_company, :realtor_phone_no, :realtor_email, :purchase_property_as, :internet_transaction_fee, :total_due, :promo_code, :property_closing_date, :hold_bid_days, :business_document_text)
      end
    end
  end
end
