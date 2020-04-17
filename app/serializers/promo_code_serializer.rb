class PromoCodeSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:promo_code] = object.promo_code
    data[:availed] = object.availed
    data
  end
end
