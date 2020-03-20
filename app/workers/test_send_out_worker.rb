class TestMailSendOutWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(mailer_template_id, email)
    mailer_template = NotificationMailerTemplate.find_by(id: mailer_template_id)
    if mailer_template
      user_id = User.find_by(is_admin: true).id
      property_id = Property.last.id
      offer_id = nil
      if mailer_template.code = "template1"
        UserVerificationMailer.verify_code(User.find_by(is_admin: true), email).deliver
      elsif mailer_template.code = "template2"
        UserVerificationMailer.welcome(User.find_by(is_admin: true), email).deliver
      elsif mailer_template.code = "template3"
        UserPasswordMailer.reset(User.find_by(is_admin: true), email).deliver
      elsif mailer_template.code = "template4"
        PropertyMailer.under_review(user_id, property_id, email).deliver
      elsif mailer_template.code = "template5"
        PropertyMailer.approved(user_id, property_id, email).deliver
      elsif mailer_template.code = "template6"
        PropertyMailer.best_offer(user_id, property_id, email).deliver
      elsif mailer_template.code = "template7"
        PropertyMailer.live_bidding(user_id, property_id, email).deliver
      elsif mailer_template.code = "template8"
        PropertyMailer.post_auction(user_id, property_id, email).deliver
      elsif mailer_template.code = "template9"
        PropertyMailer.buy_now_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template10"
        PropertyMailer.sold_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template11"
        PropertyMailer.hold_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template12"
        PropertyMailer.termination_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template13"
        PropertyMailer.buyer_best_offer_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template14"
        BestOfferMailer.not_accepted(offer_id, email, user_id, property_id).deliver
      elsif mailer_template.code = "template15"
        BestOfferMailer.out_bidded(offer_id, email, user_id, property_id).deliver
      elsif mailer_template.code = "template16"
        BidMailer.out_bidded(user_id, property_id, email).deliver
      elsif mailer_template.code = "template17"
        BidMailer.submitted(user_id, property_id, email).deliver
      elsif mailer_template.code = "template18"
        BuyNowMailer.submitted(user_id, property_id, email).deliver
      elsif mailer_template.code = "template19"
        BidMailer.highest_bidder_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template20"
        PropertyMailer.watchers_post_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template21"
        BuyNowMailer.out_bidded_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template22"
        BidMailer.termination_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template23"
        BidMailer.withdrawn_notification(user_id, property_id, email).deliver
      elsif mailer_template.code = "template24"
        PropertyMailer.urgent_chat_notification(user_id, property_id, email).deliver
      end
    end
  end
end
