class ActivitySerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:user] = object.resource_name
    data[:description] = object.description
    data[:time] = time_ago_in_words(object.created_at) + " ago"
    data
  end
end
