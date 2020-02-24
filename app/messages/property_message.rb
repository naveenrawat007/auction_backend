class PropertyMessage
  def self.under_review(user, property)
    begin
      message = "Thank you for submitting your property at #{property.address}!  You will get an email and a message in your user dashboard that will advise you when your property is approved or if we have any questions. To Your Success, \n Your Support Team @ \n AuctionMyDeal.com "
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
  def self.best_offer(user, property)
    begin
      message = "The property you submitted at #{property.address} has been approved! Check your email we just sent you that gives you"
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
  def self.live_bidding(user, property)
    begin
      message = "The property you submitted at #{property.address} is now active for Live Online Bidding status."
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
  def self.post_auction(user, property)
    begin
      message = "The property you submitted at #{property.address} is now in post auction status so go to your user panel at AuctionMyDeal.com to accept, counter or relist your property under Best Offer or Live Online Auction?"
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
