class BidMessage
  def self.highest_bidder_notification(user, property)
    begin
      message = "Congratulations for being the Highest Bidder for #{property.address}!!!  You should be getting a message from the seller in regards to finalizing a contract or providing more information to them.  Check your messages in your profile and if you don’t hear from the seller within 24 hours please let us know? To Your Success, \n Your Support Team @ \n AuctionMyDeal.com "
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
