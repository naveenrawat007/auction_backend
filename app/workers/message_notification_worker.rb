class MessageNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    user = User.find_by(id: user_id)
    if user
      PropertyMessage.chat_notification(user)
    end
  end
end
