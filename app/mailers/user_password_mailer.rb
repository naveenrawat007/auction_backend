class UserPasswordMailer < ApplicationMailer
  prepend_view_path NotificationMailerTemplate.resolver
  def reset(user, test_email=nil)#code: "template3"
	  @user = user
    if test_email
      mail(to: [test_email], subject: "Reset password instructions.")
    else
      mail(to: [@user.email], subject: "Reset password instructions.")
      UserMessage.forget_password(@user)
    end
	end
end
