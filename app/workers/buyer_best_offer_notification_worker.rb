class BuyerBestOfferNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id, user_id)
    user = User.find_by(id: user_id)
    property = Property.find_by(id: property_id)
    if user
      PropertyMailer.buyer_best_offer_notification(user.id, property.id).deliver
    end
  end
end
