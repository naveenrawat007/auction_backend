class MessageBroadcastWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(message_id)
    message = Message.find_by(id: message_id)
    if message
      begin
        Sidekiq::Client.enqueue_to_in("default", Time.now , MessageNotificationWorker, message.chat_room.property.owner.id)
      rescue ExceptionName
      end
      attachments = []
      message.attachments.each do |attachment|
        details = {
          id: attachment.id,
          file_name: attachment.file_file_name,
          file_url: APP_CONFIG['backend_site_url']+attachment.file.url,
          file_content_type: attachment.file_content_type,
          created_at: attachment.created_at.strftime("%I:%M %p")
        }
        attachments.append(details)
      end
      payload = {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        user_name: message.user.full_name,
        user_image: message.user.user_image,
        chat_room_id: message.chat_room_id,
        created_at: message.created_at.strftime("%I:%M %p"),
        attachments: attachments
      }
      ActionCable.server.broadcast(build_room_id(message.chat_room_id), payload)
    end
  end

  def build_room_id(id)
    "ChatRoom-#{id}"
  end
end
