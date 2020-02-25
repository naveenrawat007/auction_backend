class PropertyPostAuctionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if (property.status == "Approve" || property.status == "Live Online Bidding" || property.status == "Best Offer" )
        if property.post_auction_worker_jid == self.jid || property.post_auction_worker_jid.blank? == true
          if property.sniper == true
            property.sniper = false
            property.save
          else
            if property.bids.blank? == true
              property.status = "Post Auction"
            else
              property.status = "Pending"
              begin
                property.bids.order(amount: :desc).first.chat_room.update(open_connection: true)
                BidMailer.highest_bidder_notification(property.bids.order(amount: :desc).first.id).deliver
              rescue
              end
            end
            if property.save
              PropertyMailer.post_auction(property.owner_id, property.id).deliver
              Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyOutBidderNotificationWorker, @property.id)
              Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyWatchersNotificationWorker, @property.id)
            end
          end
        end
      end
    end
  end
end
