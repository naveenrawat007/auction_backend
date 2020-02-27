class MessageNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(user_id, message_id)
    user = User.find_by(id: user_id)
    message = Message.find_by(id: message_id)
    if user && message
      if message.recipient_read == false
        PropertyMessage.chat_notification(user)
      end
    end
  end
end
