class PropertyBuyNowNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id, buy_now_id)
    property = Property.find_by(id: property_id)
    if property && buy_now_id
      PropertyMailer.buy_now_notification(property.owner_id, property.id).deliver
      BuyNowMailer.submitted(buy_now_id)
      property.bids.each do |bid_offer|
        BuyNowMailer.out_bidded_notification(bid_offer.user_id, property.id)
      end
    end
  end
end
