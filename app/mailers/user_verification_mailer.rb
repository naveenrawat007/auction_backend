class UserVerificationMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver
  def verify_code(user) #code: "template1"
	  @user = user
    mail(to: [@user.email], subject: "Verify your email (Auction my deal).")
	end
  def welcome(user) #code: "template2"
    @user = user
    mail(to: [@user.email], subject: "Welcome to AuctionMyDeal.com… 😊")
    UserMessage.welcome(@user)
	end
end
