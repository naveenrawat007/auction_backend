module Api
  module V1
    class ChatRoomsController < MainController
      before_action :authorize_request
      def index
        if params[:search_str].blank? == false
          @chat_rooms = @current_user.chat_rooms.where(open_connection: true).where("lower(name) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 20)
        else
          @chat_rooms = @current_user.chat_rooms.where(open_connection: true).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
        end
        render json: {user_id: @current_user.id, chat_room_ids: @chat_rooms.ids, chat_rooms: ActiveModelSerializers::SerializableResource.new(@chat_rooms, each_serializer: ChatRoomSerializer), status: 200, meta: {current_page: @chat_rooms.current_page, total_pages: @chat_rooms.total_pages}}, status: 200
      end

      def show_messages
        @chat_room = @current_user.chat_rooms.find_by(id: params[:id])
        if @chat_room
          @messages = @chat_room.messages.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
          render json: {messages: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer), status: 200, can_reply: can_reply(@chat_room)}, status: 200
        else
          render json: {message: "Chat room not found", status: 400}, status: 200
        end
      end

      def create_messages
        @chat_room = @current_user.chat_rooms.find_by(id: params[:id])
        if @chat_room
          @message = @chat_room.messages.create(user_id: @current_user.id, content: "Attachments")
          if params[:attachments].blank? == false
            params[:attachments].each do |attachment|
              @message.attachments.create(file: attachment)
            end
            MessageBroadcastWorker.perform_at(Time.now, @message.id)
          end
          render json: {messages: ActiveModelSerializers::SerializableResource.new(@message, each_serializer: MessageSerializer), status: 200}, status: 200
        else
          render json: {message: "Chat room not found", status: 400}, status: 200
        end
      end

      def can_reply(chat_room)
        if chat_room.offer.class.to_s == "BestOffer"
          if chat_room.property.best_offer_auction_ending_at > Time.now
            true
          else
            false
          end
        else
          true
        end
      end
    end
  end
end
