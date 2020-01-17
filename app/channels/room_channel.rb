class RoomChannel < ApplicationCable::Channel
  # calls when a client connects to the server
  def subscribed
    if params[:room_id].present?
      stream_from("ChatRoom-#{(params[:room_id])}")
    end
  end

  # calls when a client broadcasts data
  def speak(data)
    # puts"11111111111111111111111111111111111111111111111111111111111111"
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
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    message = Message.create(
      chat_room: chat_room,
      user: sender,
      content: message
    )
    payload = {
      chat_room_id: message.chat_room_id,
      content: message.content,
      sender: message.user_id,
    }
    ActionCable.server.broadcast(build_room_id(message.chat_room_id), payload)

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
