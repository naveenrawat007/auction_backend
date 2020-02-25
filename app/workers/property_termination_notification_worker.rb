class PropertyTerminationNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4
  def perform(property_id, user_ids, offer_type)
    property = Property.find_by(id: property_id)
    if property
      if offer_type == "Bid"
        if user_ids.blank? == false
          user_ids.each do |user_id|
            BidMailer.termination_notification(user_id, property.id).deliver
          end
        end
      end
    end
  end
end
