class PropertyBidNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id, bid_id)
    property = Property.find_by(id: property_id)
    bid = Bid.find_by(id: bid_id)
    if property
      PropertyMailer.bid_notification(property.owner_id, property.id).deliver
      if bid
        BidMailer.submitted(bid.id).deliver
      end
    end
  end
end
