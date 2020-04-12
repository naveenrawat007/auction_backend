class SubscriberWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(id)
    SubscriberMailer.auction_guide(id).deliver
  end

end
