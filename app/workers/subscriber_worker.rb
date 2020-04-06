class SubscriberWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(email, name)
    SubscriberMailer.auction_guide(email, name).deliver
  end

end
