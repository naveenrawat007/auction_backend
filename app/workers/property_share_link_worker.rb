class PropertyShareLinkWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(email, property_id, link)
    property = Property.find_by(id: property_id)
    if property
      PropertyMailer.share_link(email, link).deliver
    end
  end
end
