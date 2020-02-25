class PropertyLiveWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.live_auction_worker_jid == self.jid || property.live_auction_worker_jid.blank? == true
        if (property.status == "Approve" || property.status == "Best Offer" )
          property.status = "Live Online Bidding"
          property.save
          PropertyMailer.live_bidding(property.owner_id, property.id).deliver
          if property.best_offer == true
            Sidekiq::Client.enqueue_to_in("default", Time.now , BestOffersChecksWorker, property.id)
          end
        end
      end
    end
  end
end
