class ActivityNotificationWorker
  include ActionView::Helpers::DateHelper
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(activity_id)
    activity = Activity.find_by(id: activity_id)
    if activity
      if ['request_for_termination','property_posted','buy_now_submission'].include?(activity.act_type)
        payload = {
          id: activity.id,
          user: activity.resource_name,
          description: activity.description,
          time: time_ago_in_words(activity.created_at) + " ago",
        }
        ActionCable.server.broadcast("notification_channel", payload)
      end
    end
  end
end
