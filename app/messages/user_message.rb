class UserMessage < MainMessage
  def self.welcome(user, number=nil) #code: "template2"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template2").body, user)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
  def self.verify_code(user, number=nil) #code: "template1"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template1").body, user)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send_code("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
  def self.forget_password(user, number=nil) #code: "template3"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template3").body, user)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
end
