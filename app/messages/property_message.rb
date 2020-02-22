class PropertyMessage
  def self.under_review(user, property)
    begin
      message = "Thank you for submitting your property at #{property.address}! Our staff will evaluate your property to determine if it meets these requirements, and will get back to you in less than 12 to 24 hours."
      MessageSender.send("+1#{user.phone_number}", message)
    rescue StandardError => e
    end
  end
end
