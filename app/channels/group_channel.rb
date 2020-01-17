class GroupChannel < ApplicationCable::Channel
  # calls when a client connects to the server
  def subscribed
    if params[:group_id].present?
      stream_from("ChatRoom-#{(params[:group_id])}")
    end
  end

  # calls when a client broadcasts data
  def speak(data)
    # puts"11111111111111111111111111111111111111111111111111111111111111"
    sender    = get_sender(data['sender'])
    group_id   = data['group_id']
    message   = data['message']

    raise 'No room_id!' if group_id.blank?
    group = get_group(group_id) # A conversation is a room
    raise 'No conversation found!' if group.blank?
    raise 'No message!' if message.blank?

    # adds the message sender to the conversation if not already included
    group.users << sender unless group.users.include?(sender)
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    message = Message.create(
      group: group,
      user: sender,
      content: message
    )
    payload = {
      group_id: message.group.id,
      content: message.content,
      sender: message.user_id,
    }
    ActionCable.server.broadcast(build_room_id(message.group.id), payload)

  end

  # Helpers
  def build_room_id(id)
    "ChatRoom-#{id}"
  end

  def get_group(group_id)
    Group.find_by(id: group_id)
  end

  def get_sender(id)
    User.find_by(id: id)
  end
end
