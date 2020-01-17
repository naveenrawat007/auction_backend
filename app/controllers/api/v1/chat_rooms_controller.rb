module Api
  module V1
    class ChatRoomsController < MainController
      before_action :authorize_request
      def index
        @chat_rooms = @current_user.chat_rooms
        render json: {chat_rooms: ActiveModelSerializers::SerializableResource.new(@chat_rooms, each_serializer: ChatRoomSerializer), status: 200}, status: 200
      end

      def show_messages
        @chat_room = @current_user.chat_rooms.find_by(id: params[:room_id])
        if @chat_room
          @messages = @chat_room.messages.order(create_at: :desc)
          render json: {messages: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer), status: 200}, status: 200
        else
          render json: {message: "Chat room not found", status: 400}, status: 200
        end
      end

      def create_messages
        @chat_room = @current_user.chat_rooms.find_by(id: params[:room_id])
        if @group
          @message = @chat_room.messages.create(user_id: @current_user.id, content: params[:content])
          render json: {messages: ActiveModelSerializers::SerializableResource.new(@message, each_serializer: MessageSerializer), status: 200}, status: 200
        else
          render json: {message: "Chat room not found", status: 400}, status: 200
        end
      end
    end
  end
end
