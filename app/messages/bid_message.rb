class BidMessage < MainMessage
  def self.highest_bidder_notification(user, property, number=nil) #code: "template19"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template19").body, user, property)
      if number
        MessageSender.send("+1#{number}", message)
      else
        MessageSender.send("+1#{user.phone_number}", message)
      end
    rescue StandardError => e
    end
  end
end
