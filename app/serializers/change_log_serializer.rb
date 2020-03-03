class ChangeLogSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:details] = object.details
    data[:created_at] = object.created_at.strftime("%m/%d/%Y")
    data
  end
end
