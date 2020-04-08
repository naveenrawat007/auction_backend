class SubscriberWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(id)
    subscriber = Subscriber.find_by(id: id)
    SubscriberMailer.auction_guide(subscriber.email, subscriber.name).deliver
  end

end
