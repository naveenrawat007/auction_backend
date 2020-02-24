class PropertyMessage
  def self.under_review(user, property)
    begin
      message = "Thank you for submitting your property at #{property.address}!  You will get an email and a message in your user dashboard that will advise you when your property is approved or if we have any questions. To Your Success, \n Your Support Team @ \n AuctionMyDeal.com "
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
