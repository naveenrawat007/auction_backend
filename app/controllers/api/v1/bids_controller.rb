module Api
  module V1
    class BidsController < MainController
      before_action :authorize_request
      def create
        @property = Property.find_by(id: params[:property][:id])
        if @property
          if @property.owner_id == @current_user.id
            render json: {property: PropertySerializer.new(@property), message: "Can not submit proposal on own property.", status: 400 }, status: 200 and return
          else
            hightest_bid_offer = @property.highest_bid
            if @property.bidding_ending_at > Time.now
              if params[:bid][:amount].to_f > hightest_bid_offer.to_f
                @bid = @property.bids.where(user_id: @current_user.id).first_or_create
                @bid.user_id = @current_user.id
                @bid.amount = params[:bid][:amount]
                @bid.buy_option = buy_option_permitter
                @bid.save
                if (@property.bidding_ending_at - Time.now < 1.minutes) #time check for bidding time
                  @property.sniper = true
                  @property.sniper_length += 3 #count of time duration increasing in minutes
                  @property.save
                  post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.bidding_ending_at, PropertyPostAuctionWorker, @property.id)
                  @property.post_auction_worker_jid = post_auction_worker_jid
                  @property.save
                end
                Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyBidNotificationWorker, @property.id)
                if params[:bid][:fund_proof].blank? == false
                  @bid.fund_proofs.destroy_all
                  @bid.fund_proofs.create(file: params[:bid][:fund_proof])
                end
                #creating chatrooms
                @chat_room = @current_user.chat_rooms.where(property_id: @property.id).first
                unless @chat_room
                  @chat_room = @current_user.chat_rooms.new(property_id: @property.id)
                  @chat_room.name = @property.address
                  @chat_room.offer = @bid
                  @chat_room.save
                  @chat_room.users << @property.owner
                  @chat_room.users << @current_user
                  message = @chat_room.messages.new
                  message.content = "I have submitted Bid in your property at #{@property.address} for $#{@bid.amount} and check proof of funds."
                  message.user_id = @current_user.id
                  message.save
                  if @bid.fund_proofs.blank? == false
                    message.attachments.create(file: File.open(@bid.fund_proofs.first.file.path,'rb'))
                  end
                end
                #end
                render json: {chat_room: ChatRoomSerializer.new(@chat_room), property: PropertySerializer.new(@property), message: "Bid Created.", status: 201 }, status: 200
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
      end
      private
      def buy_option_permitter
        JSON.parse(params[:bid][:buy_option])
      end
    end
  end
end
