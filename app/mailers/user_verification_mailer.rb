class UserVerificationMailer < ApplicationMailer
  def verify_code(user)
	  @user = user
    mail(to: [@user.email], subject: "Verify your email (Auction my deal).")
	end
  def welcome(user)
    @user = user
    mail(to: [@user.email], subject: "Welcome to AuctionMyDeal.com… 😊")
    UserMessage.welcome(@user)
	end
end
