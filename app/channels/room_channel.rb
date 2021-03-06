class RoomChannel < ApplicationCable::Channel
  # calls when a client connects to the server
  def subscribed
    if params[:room_id].present?
      stream_from("ChatRoom-#{(params[:room_id])}")
    end
  end

  # calls when a client broadcasts data
  def read(data)
    message_id = data['message']
    message = Message.find_by(id: message_id)
    if message.user_id != data['sender'] && get_sender(data['sender']).is_admin == false
      message.update(recipient_read: true)
    else
      if message.chat_room.property.owner.id != data['sender']
        Sidekiq::Client.enqueue_to_in("default", Time.now + 30.seconds, MessageNotificationWorker, message.chat_room.property.owner.id, message_id)
      else
        Sidekiq::Client.enqueue_to_in("default", Time.now + 30.seconds, UrgentMessageNotificationWorker, data['sender'], message_id)
      end
    end
  end
  def speak(data)
    sender    = get_sender(data['sender'])
    room_id   = data['room_id']
    message   = data['message']
    puts "#{room_id}"
    raise 'No room_id!' if room_id.blank?
    chat_room = get_chat_room(room_id)
    raise 'No Chat Room found!' if chat_room.blank?
    raise 'No message!' if message.blank?

    # adds the message sender to the conversation if not already included
    chat_room.users << sender unless chat_room.users.include?(sender)
    if chat_room.open_connection == false
      if sender.id == chat_room.owner.id
        chat_room.open_connection = true
        chat_room.save
      end
    end
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    if chat_room.open_connection == true
      message = Message.create(
        chat_room: chat_room,
        user: sender,
        content: message
      )
    end
  end

  # Helpers
  def build_room_id(id)
    "ChatRoom-#{id}"
  end

  def get_chat_room(room_id)
    ChatRoom.find_by(id: room_id)
  end

  def get_sender(id)
    User.find_by(id: id)
  end
end
