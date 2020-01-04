class PropertyPostAuctionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status = "Approve"
        property.status = "Post Auction"
        if property.save
          PropertyMailer.post_auction(property.owner_id, property.id).deliver
        end
      end
    end
  end
end
