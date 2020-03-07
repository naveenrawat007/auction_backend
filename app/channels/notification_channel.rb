class NotificationChannel < ApplicationCable::Channel
  # calls when a client connects to the server
  def subscribed
    stream_from("notification_channel")
  end
end
