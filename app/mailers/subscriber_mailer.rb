class SubscriberMailer < ApplicationMailer

  def auction_guide(email, name)
    @name = name
    attachments['auction_guide.pdf'] = File.read("#{Rails.root}/app/assets/dummy.pdf")
    mail(to: email, subject: "Auction Guide")
	end

end
