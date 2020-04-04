module Api
  module V1
    class BuyNowOffersController < MainController
      before_action :authorize_request
      include ActionView::Helpers::NumberHelper
      def create
        @property = Property.find_by(id: params[:property][:id])
        if @property
          if @property.owner_id == @current_user.id
            render json: {property: PropertySerializer.new(@property), message: "Can not submit proposal on own property.", status: 400 }, status: 200 and return
          else
            if params[:best_offer] == "true"
              if check_best_offer_time #&& @property.status == "Best Offer"
                @buy_now = @property.best_buy_nows.where(user_id: @current_user.id).first_or_create
                @buy_now.user_id = @current_user.id
                @buy_now.amount = params[:buy_now][:amount]
                @buy_now.buy_option = buy_option_permitter
                @buy_now.save
                if !@buy_now.offer_detail
                  @offer_detail = @buy_now.build_offer_detail(offer_detail_params)
                else
                  @offer_detail = @buy_now.offer_detail
                  @offer_detail.update(offer_detail_params)
                end
                @offer_detail.save
                if !(params[:bid][:business_documents].blank?)
                  @offer_detail.business_documents.destroy_all
                  params[:bid][:business_documents].each do |document|
                    @offer_detail.business_documents.create(file: document)
                  end
                end
                CreateActivityService.new(@buy_now, "buy_now_submission").process!
                @property.status = "Pending"
                @property.save
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyBuyNowNotificationWorker, @property.id, @buy_now.id)
                if params[:buy_now][:fund_proof].blank? == false
                  @buy_now.fund_proofs.destroy_all
                  @buy_now.fund_proofs.create(file: params[:buy_now][:fund_proof])
                end
                #creating chatrooms
                @chat_room = @current_user.chat_rooms.where(property_id: @property.id, offer: @buy_now).first
                unless @chat_room
                  @chat_room = @current_user.chat_rooms.new(property_id: @property.id)
                  @chat_room.name = @property.address
                  @chat_room.offer = @buy_now
                  @chat_room.save
                  @chat_room.users << @property.owner
                  @chat_room.users << @current_user
                  message = @chat_room.messages.new
                  message.content = "I have submitted Buy Now in your property at #{@property.address} for #{number_to_currency(@buy_now.amount)} and check proof of funds."
                  message.user_id = @current_user.id
                  message.save
                  if params[:buy_now][:fund_proof].blank? == false
                    message.attachments.create(file: params[:buy_now][:fund_proof])
                  end
                end
                #end
                render json: {chat_room: ChatRoomSerializer.new(@chat_room), property: PropertySerializer.new(@property), message: "Offer Created.", status: 201 }, status: 200
              else
                render json: { message: "Can not Submit buy now.", status: 400 }, status: 200
              end
            else
              @buy_now = @property.buy_nows.where(user_id: @current_user.id).first_or_create
              @buy_now.user_id = @current_user.id
              @buy_now.amount = params[:buy_now][:amount]
              @buy_now.buy_option = buy_option_permitter
              @buy_now.save
              if !@buy_now.offer_detail
                @offer_detail = @buy_now.build_offer_detail(offer_detail_params)
              else
                @offer_detail = @buy_now.offer_detail
                @offer_detail.update(offer_detail_params)
              end
              @offer_detail.save
              if !(params[:bid][:business_documents].blank?)
                @offer_detail.business_documents.destroy_all
                params[:bid][:business_documents].each do |document|
                  @offer_detail.business_documents.create(file: document)
                end
              end
              CreateActivityService.new(@buy_now, "buy_now_submission").process!
              @property.status = "Pending"
              @property.save
              Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyBuyNowNotificationWorker, @property.id, @buy_now.id)
              if params[:buy_now][:fund_proof].blank? == false
                @buy_now.fund_proofs.destroy_all
                @buy_now.fund_proofs.create(file: params[:buy_now][:fund_proof])
              end
              #creating chatrooms
              @chat_room = @current_user.chat_rooms.where(property_id: @property.id, offer: @buy_now).first
              unless @chat_room
                @chat_room = @current_user.chat_rooms.new(property_id: @property.id)
                @chat_room.name = @property.address
                @chat_room.offer = @buy_now
                @chat_room.save
                @chat_room.users << @property.owner
                @chat_room.users << @current_user
                message = @chat_room.messages.new
                message.content = "I have submitted Buy Now in your property at #{@property.address} for #{number_to_currency(@buy_now.amount)} and check proof of funds."
                message.user_id = @current_user.id
                message.save
                if params[:buy_now][:fund_proof].blank? == false
                  message.attachments.create(file: params[:buy_now][:fund_proof])
                end
              end
              #end
              render json: {chat_room: ChatRoomSerializer.new(@chat_room), property: PropertySerializer.new(@property), message: "Offer Created.", status: 201 }, status: 200
            end
          end
        else
          render json: {message: "Property Not Found.", status: 404}, status: 200
        end
      end
      private
      def check_best_offer_time
        if @property.best_offer == true
          if (Time.now < @property.best_offer_auction_ending_at)
            true
          else
            false
          end
        else
          false
        end
      end
      def buy_option_permitter
        JSON.parse(params[:buy_now][:buy_option])
      end
      def offer_detail_params
        params.require(:buy_now).permit(:user_first_name, :user_middle_name, :user_last_name, :user_email, :user_phone_no, :self_buy_property, :realtor_first_name, :realtor_last_name, :realtor_license, :realtor_company, :realtor_phone_no, :realtor_email, :purchase_property_as, :internet_transaction_fee, :total_due, :promo_code, :property_closing_date, :hold_bid_days, :business_document_text)
      end
    end
  end
end
