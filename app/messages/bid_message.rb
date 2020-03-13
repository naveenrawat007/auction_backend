class BidMessage < MainMessage
  def self.highest_bidder_notification(user, property) #code: "template19"
    begin
      message = self.manage_body(NotificationMessageTemplate.find_by(code: "template19").body, user, property)
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
