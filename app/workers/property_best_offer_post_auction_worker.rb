class PropertyBestOfferPostAuctionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id, pass = false)
    property = Property.find_by(id: property_id)
    if property
      if property.best_offer_post_auction_worker_jid == self.jid || property.best_offer_post_auction_worker_jid.blank? == true || pass
        if property.status == "Best Offer"
          property.status = "Post Auction"
          property.save
          # PropertyMailer.best_offer_ended(property.owner_id, property.id).deliver
        end
      end
    end
  end
end
