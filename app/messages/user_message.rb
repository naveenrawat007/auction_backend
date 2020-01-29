class UserMessage
  def self.welcome(user)
    begin
      message = "Thank you for registering as a free member at www.AuctionMyDeal.com!  Your account has been verified. Enjoy your 60 day free trial."
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
