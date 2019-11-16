class UserPasswordMailer < ApplicationMailer
  def reset(user)
	  @user = user
    mail(to: [@user.email], subject: "Reset password instructions.")
	end
end
