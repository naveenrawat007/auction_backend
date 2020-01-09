class PropertyDraftWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Under Review"
        property.status = "Draft"
        property.requested = false
        if property.save
          Sidekiq::Client.enqueue_to_in("default", Time.now , PropertyNotificationWorker, property.id)
        end
      end
    end
  end
end
