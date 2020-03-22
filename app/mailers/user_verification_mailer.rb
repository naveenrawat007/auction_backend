class UserVerificationMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver
  def verify_code(user, test_email=nil) #code: "template1"
	  @user = user
    if test_email
      mail(to: test_email, subject: "Verify your email (Auction my deal).")
    else
      mail(to: [@user.email], subject: "Verify your email (Auction my deal).")
      UserMessage.verify_code(@user)
    end
	end
  def welcome(user, test_email) #code: "template2"
    @user = user
    if test_email
      mail(to: test_email, subject: "Welcome to AuctionMyDeal.com… 😊")
    else
      mail(to: [@user.email], subject: "Welcome to AuctionMyDeal.com… 😊")
      UserMessage.welcome(@user)
    end
	end
end
