class MessageSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:content] = object.content
    data[:user_id] = object.user_id
    data[:user_name] = object.user.full_name
    data[:user_image] = object.user.user_image
    data[:chat_room_id] = object.chat_room_id
    data[:created_at] = object.created_at.strftime("%I:%M %p")
    data[:attachments] = ActiveModelSerializers::SerializableResource.new(object.attachments, each_serializer: AttachmentSerializer)
    data
  end
end
