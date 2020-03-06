class PropertyStatusRequestNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id, status)
    property = Property.find_by(id: property_id)
    if property
      if status == "Terminated"
        PropertyMailer.request_termination_notification(property.owner_id, property.id).deliver
      end
    end
  end
end
