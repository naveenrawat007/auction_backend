class SubscriberSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:name] = object.name
    data[:phone_number] = object.phone_no
    data[:email] = object.email
    data
  end
end
