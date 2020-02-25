class BestOffersChecksWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      property.best_offers.where(accepted: false).each do |best_offer|
        BestOfferMailer.not_accepted(best_offer.id).deliver
      end
    end
  end
end
