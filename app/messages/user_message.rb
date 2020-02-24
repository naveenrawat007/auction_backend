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
      message = "We heard you need a password reset. Click the link below and you'll be redirected to a secure site from which you can set a new password. \n #{APP_CONFIG['site_url']}/new_password?reset_token=#{user.auth_token} \n If you didn't try to reset your password then ignore this email. \n Best Regards, \n Your Support Team @ \n AuctionMyDeal.com"
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
