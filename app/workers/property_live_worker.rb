class PropertyLiveWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Approve / Best Offer"
        property.status = "Live Online Bidding"
        property.save
        PropertyMailer.live_bidding(property.owner_id, property.id).deliver
      end
    end
  end
end
