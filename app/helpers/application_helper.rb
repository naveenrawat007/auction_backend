module ApplicationHelper
  def best_offer_live_auction(property)
    @property = property
    delete_job(@property.best_offer_live_auction_worker_jid)
    @property.best_offer_live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.best_offer_auction_started_at , PropertyBestOfferWorker, @property.id)
    @property.save
  end

  def best_offer_post_auction(property)
    @property = property
    delete_job(@property.best_offer_post_auction_worker_jid)
    @property.best_offer_post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.best_offer_auction_ending_at, PropertyBestOfferPostAuctionWorker, @property.id)
    @property.save
  end

  def live_auction(property)
    @property = property
    delete_job(@property.live_auction_worker_jid)
    @property.live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.auction_started_at , PropertyLiveWorker, @property.id)
    @property.save
  end

  def post_auction(property)
    @property = property
    delete_job(@property.post_auction_worker_jid)
    @property.post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", @property.auction_bidding_ending_at + @property.sniper_length.minutes, PropertyPostAuctionWorker, @property.id)
    @property.save
  end

  def delete_job(jid)
    if jid.blank? == false
      report_job = Sidekiq::ScheduledSet.new.find_job(jid)
      report_job.try(:delete)
    end
  end
end
