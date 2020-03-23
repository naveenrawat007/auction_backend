class TestMessageSendOutWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(message_template_id, number)
    message_template = NotificationMessageTemplate.find_by(id: message_template_id)
    if message_template
      user = User.find_by(is_admin: true)
      property = Property.last
      offer_id = nil
      if message_template.code == "template1"
        UserMessage.verify_code(user, number)
      elsif message_template.code == "template2"
        UserMessage.welcome(user, number)
      elsif message_template.code == "template3"
        UserMessage.forget_password(user, number)
      elsif message_template.code == "template4"
        PropertyMessage.under_review(user, property, number)
      elsif message_template.code == "template6"
        PropertyMessage.best_offer(user, property, number)
      elsif message_template.code == "template7"
        PropertyMessage.live_bidding(user, property, number)
      elsif message_template.code == "template8"
        PropertyMessage.post_auction(user, property, number)
      elsif message_template.code == "template9"
        PropertyMessage.buy_now_notification(user, property, number)
      elsif message_template.code == "template10"
        PropertyMessage.sold_notification(user, property, number)
      elsif message_template.code == "template12"
        PropertyMessage.termination_notification(user, property, number)
      elsif message_template.code == "template13"
        PropertyMessage.buyer_best_offer_notification(user, property, number)
      elsif message_template.code == "template19"
        BidMessage.highest_bidder_notification(user, property, number)
      elsif message_template.code == "template20"
        PropertyMessage.watchers_post_notification(user, property, number)
      elsif message_template.code == "template24"
        PropertyMessage.chat_notification(user, number)
      elsif message_template.code == "template25"
        PropertyMessage.urgent_chat_notification(user, property, number)
      end
    end
  end
end
