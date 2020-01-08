class PropertyApproveWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Under Review"
        property.status = "Approve"
        if property.save
          PropertyMailer.approved(property.owner_id, property.id).deliver
          if property.auction_started_at.blank? == false
            if property.best_offer == true
              Sidekiq::Client.enqueue_to_in("default", property.auction_started_at , PropertyBestOfferWorker, property.id)
              Sidekiq::Client.enqueue_to_in("default", property.auction_started_at + property.best_offer_length.to_i.days , PropertyLiveWorker, property.id)
            else
              Sidekiq::Client.enqueue_to_in("default", property.auction_started_at , PropertyLiveWorker, property.id)
            end
            Sidekiq::Client.enqueue_to_in("default", property.bidding_ending_at, PropertyPostAuctionWorker, property.id)
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
