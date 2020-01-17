class ChatRoomSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name
    data[:owner_name] = object.property.owner.full_name
    data[:owner_img] = object.property.owner.user_image
    data[:property_name] = object.property.address
    data
  end
end
