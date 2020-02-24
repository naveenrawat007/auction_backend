class PropertyNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4
  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      if property.status == "Hold"
        PropertyMailer.hold_notification(property.owner_id, property.id).deliver
      elsif property.status == "Terminated"
        PropertyMailer.termination_notification(property.owner_id, property.id).deliver
      else
        PropertyMailer.status_notification(property.owner_id, property.id).deliver
      end
    end
  end
end
