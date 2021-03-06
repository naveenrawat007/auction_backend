module Api
  module V1
    module Admin
      class ChatRoomsController < Api::V1::MainController
        before_action :authorize_admin_request
        def index
          if params[:search_str].blank? == false
            @chat_rooms = ChatRoom.where("lower(name) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :desc).paginate(page: params[:page], per_page: 20)
          else
            @chat_rooms = ChatRoom.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
          end
          render json: {user_id: @current_user.id, chat_rooms: ActiveModelSerializers::SerializableResource.new(@chat_rooms, each_serializer: ChatRoomSerializer), status: 200, meta: {current_page: @chat_rooms.current_page, total_pages: @chat_rooms.total_pages}}, status: 200
        end
        def show_messages
          @chat_room = ChatRoom.find_by(id: params[:id])
          if @chat_room
            @messages = @chat_room.messages.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
            render json: {messages: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer), status: 200}, status: 200
          else
            render json: {message: "Chat room not found", status: 400}, status: 200
          end
        end
        def create_messages
          @chat_room = ChatRoom.find_by(id: params[:id])
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
      end
    end
  end
end
