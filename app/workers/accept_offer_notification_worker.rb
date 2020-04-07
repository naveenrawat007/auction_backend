class AcceptOfferNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id, offer_id, offer_type)
    property = Property.find_by(id: property_id)
    if property
      if offer_type == "bid"
        bid = property.bids.find_by(id: offer_id)
        if bid
          # PropertyMailer.bid_accept(property.owner_id, property.id, bid.user_id).deliver
        end
      elsif offer_type == "best_offer"
        best_offer = property.best_offers.find_by(id: offer_id)
        if best_offer
          # PropertyMailer.best_offer_accept(property.owner_id, property.id, best_offer.user_id).deliver
          property.best_offers.where.not(id: offer_id).each do |best_offer|
            BestOfferMailer.out_bidded(best_offer.id).deliver
          end
        end
      elsif (offer_type == "buy_now"|| offer_type == "best_buy_now")
        buy_now = property.buy_now_offers.find_by(id: offer_id)
        if buy_now
          # PropertyMailer.buy_now_accept(property.owner_id, property.id, buy_now.user_id).deliver
        end
      end
    end
  end
end
