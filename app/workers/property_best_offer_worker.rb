class PropertyBestOfferWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Approve"
        property.status = "Best Offer"
        property.save
        PropertyMailer.best_offer(property.owner_id, property.id).deliver
      end
    end
  end
end
