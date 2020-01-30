class UserPasswordMailer < ApplicationMailer
  def reset(user)
	  @user = user
    mail(to: [@user.email], subject: "Reset password instructions.")
    UserMessage.forget_password(@user)
	end
end
