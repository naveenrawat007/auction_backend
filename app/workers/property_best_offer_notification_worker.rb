class PropertyBestOfferNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      PropertyMailer.best_offer_notification(property.owner_id, property.id).deliver
    end
  end
end
