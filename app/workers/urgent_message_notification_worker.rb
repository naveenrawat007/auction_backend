class MessageNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(user_id, message_id)
    user = User.find_by(id: user_id)
    message = Message.find_by(id: message_id)
    if user && message
      if message.recipient_read == false
        PropertyMailer.urgent_chat_notification(user.id, message.chat_room.property.id).deliver
      end
    end
  end
end
