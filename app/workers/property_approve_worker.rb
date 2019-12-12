class PropertyApproveWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Under Review"
        property.status = "Approve / Best Offer"
        if property.save
          PropertyMailer.approved(property.owner_id, property.id).deliver
        end
      end
    end
  end
end
