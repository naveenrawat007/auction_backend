class UserPasswordMailer < ApplicationMailer
  def reset(user)#code: "template3"
	  @user = user
    mail(to: [@user.email], subject: "Reset password instructions.")
    UserMessage.forget_password(@user)
	end
end
