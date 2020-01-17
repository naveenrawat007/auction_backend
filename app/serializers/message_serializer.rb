class MessageSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:content] = object.content
    data[:user_id] = object.user_id
    data[:chat_room_id]= object.chat_room_id
    data
  end
end
