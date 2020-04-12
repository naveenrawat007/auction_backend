class SubscriberMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver

  def auction_guide(subscriber_id, test_email=nil) #code: "template25"
    @subscriber = Subscriber.find_by(id: subscriber_id)
    if @subscriber
      attachments['auction_guide.pdf'] = File.read("#{Rails.root}/app/assets/dummy.pdf")
      if test_email
        mail(to: test_email, subject: "Auction Guide")
      else
        mail(to: [@subscriber.email], subject: "Auction Guide")
      end
    end
	end

end
