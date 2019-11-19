class UserVerificationMailer < ApplicationMailer
  def verify_code(user)
	  @user = user
    mail(to: [@user.email], subject: "Verify your email (Auction my deal).")
	end
end
