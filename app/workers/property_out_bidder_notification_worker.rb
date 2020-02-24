class PropertyOutBidderNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      property.bids.where.not(amount: property.bids.maximum(:amount)).each do |best_offer|
        BidMailer.out_bidded(best_offer.id).deliver
      end
    end
  end

end
