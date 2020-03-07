class ActivitySerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:user] = object.resource_name
    data[:description] = object.description
    data[:time] = time_ago_in_words(object.created_at) + " ago"
    data[:text_description] = object.text_description
    if ['property_posted', 'request_for_termination', 'property_bidding_ended'].include?(object.act_type)
      data[:property] = UserPropertySerializer.new(object.resource)
    elsif ['bid_submission','offer_submission','buy_now_submission'].include?(object.act_type)
      data[:property] = UserPropertySerializer.new(object.resource.property)
    end
    data
  end
end
