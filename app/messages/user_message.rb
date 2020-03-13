class UserMessage < MainMessage
  def self.welcome(user) #code: "template2"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template2").body, user)
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
  def self.verify_code(user) #code: "template1"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template1").body, user)
      MessageSender.send_code("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
  def self.forget_password(user) #code: "template3"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template3").body, user)
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
