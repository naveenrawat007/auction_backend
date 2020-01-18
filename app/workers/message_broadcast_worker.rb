class MessageBroadcastWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(message_id)
    message = Message.find_by(id: message_id)
    if message
      payload = {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        user_name: message.user.full_name,
        user_image: message.user.user_image,
        chat_room_id: message.chat_room_id,
        created_at: message.created_at.strftime("%I:%M %p")
      }
      ActionCable.server.broadcast(build_room_id(message.chat_room_id), payload)
    end
  end

  def build_room_id(id)
    "ChatRoom-#{id}"
  end
end
