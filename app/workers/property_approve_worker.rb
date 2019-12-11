class PropertyApproveWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Under Review"
        property.status = "Approve / Best Offer"
        property.save
      end
    end
  end
end
