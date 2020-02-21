class PropertyApproveWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Under Review"
        property.status = "Approve"
        property.submitted = false
        if property.save
          PropertyMailer.approved(property.owner_id, property.id).deliver
          if property.auction_started_at.blank? == false
            if property.best_offer == true
              if property.best_offer_auction_started_at.blank? == false
                @property.best_offer_live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.best_offer_auction_started_at , PropertyBestOfferWorker, property.id)
              end
              if property.best_offer_auction_ending_at.blank? == false
                @property.best_offer_post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.auction_started_at + property.best_offer_length.to_i.days , PropertyBestOfferPostAuctionWorker, property.id)
              end
            end
            property.live_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.auction_started_at , PropertyLiveWorker, property.id)
            property.post_auction_worker_jid = Sidekiq::Client.enqueue_to_in("default", property.auction_bidding_ending_at, PropertyPostAuctionWorker, property.id)
            property.save
          else
            property.status = "Hold"
            property.save
            Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, property.id)
          end
        end
      end
    end
  end
end
