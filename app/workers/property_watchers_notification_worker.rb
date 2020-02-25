class PropertyWatchersNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(property_id)
    property = Property.find_by(id: property_id)
    if property
      property.user_watch_properties.map(&:user_id).each do |user_id|
        PropertyMailer.watchers_post_notification(property.id, user_id).deliver
      end
    end
  end
end
