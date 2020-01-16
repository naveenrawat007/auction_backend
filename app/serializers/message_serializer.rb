class MessageSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:content] = object.content
    data[:user_id] = object.user_id
    data[:group_id]= object.group_id
    data
  end
end
