class PropertyMessage < MainMessage
  ADMIN_NUMBERS = [7135531331, 9044900044]
  def self.under_review(user, property, number=nil) #code: "template4"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template4").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
  def self.best_offer(user, property, number=nil) #code: "template6"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template6").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
  def self.live_bidding(user, property, number=nil) #code: "template7"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template7").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
  def self.post_auction(user, property, number=nil) #code: "template8"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template8").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.buy_now_notification(user, property, number=nil) #code: "template9"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template9").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.sold_notification(user, property, number=nil) #code: "template10"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template10").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.chat_notification(user, number=nil) #code: "template24"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template24").body, user)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.buyer_best_offer_notification(user, property, number=nil) #code: "template13"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template13").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.watchers_post_notification(user, property, number=nil) #code: "template20"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template20").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.termination_notification(user, property, number=nil) #code: "template12"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template12").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
  def self.request_termination_notification(user, property)
    begin
      ADMIN_NUMBERS.each do |phone_number|
        message = "#{user.first_name} is requesting for property termination at #{property.address}."
        MessageSender.send("+1#{phone_number}", message)
      end
    rescue StandardError => e
    end
  end

  def self.urgent_chat_notification(user, property, number=nil) #code: "template25"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template25").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
end
