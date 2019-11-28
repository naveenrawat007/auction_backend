class SellerPayTypeSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name
    data[:description] = object.description
    data
  end
end
