class UserMessage
  def self.welcome(user)
    begin
      message = "Thank you for registering as a free member at www.AuctionMyDeal.com!  Your account has been verified. Enjoy your 60 day free trial."
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
  def self.forget_password(user)
    begin
      message = "We heard you need a password reset. Please check your email to reset your password."
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
