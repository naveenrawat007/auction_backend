module Api
  module V1
    class BuyNowOffersController < MainController
      before_action :authorize_request
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
                @property.status = "Pending"
                @property.save
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
                  message.content = "I have submitted Buy Now in your property at #{@property.address} for $#{@buy_now.amount} and check proof of funds."
                  message.user_id = @current_user.id
                  message.save
                  if @buy_now.fund_proofs.blank? == false
                    message.attachments.create(file: File.open(@buy_now.fund_proofs.first.file.path,'rb'))
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
              @property.status = "Pending"
              @property.save
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
                message.content = "I have submitted Buy Now in your property at #{@property.address} for $#{@buy_now.amount} and check proof of funds."
                message.user_id = @current_user.id
                message.save
                if @buy_now.fund_proofs.blank? == false
                  message.attachments.create(file: File.open(@buy_now.fund_proofs.first.file.path,'rb'))
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
          if (Time.now < @property.auction_started_at + @property.best_offer_length.to_i.days)
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
    end
  end
end
