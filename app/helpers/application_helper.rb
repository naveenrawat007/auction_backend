module ApplicationHelper
  def best_offer_live_auction(property)
    @property = property
    @property.best_offer_live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.best_offer_auction_started_at , PropertyBestOfferWorker, @property.id)
    @property.save
  end

  def best_offer_post_auction(property)
    @property = property
    @property.best_offer_post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.best_offer_auction_ending_at, PropertyBestOfferPostAuctionWorker, @property.id)
    @property.save
  end

  def live_auction(property)
    @property = property
    @property.live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyLiveWorker, @property.id)
    @property.save
  end

  def post_auction(property)
    @property = property
    @property.post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.auction_bidding_ending_at, PropertyPostAuctionWorker, @property.id)
    @property.save
  end
end
