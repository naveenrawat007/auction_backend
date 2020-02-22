class MessageSender
  def self.send_code(phone_number, code)

    account_sid =  Rails.application.credentials.twilio_account_sid
    auth_token  =  Rails.application.credentials.twilio_auth_token
    client = Twilio::REST::Client.new(account_sid, auth_token)

    # message = client.messages.create(
    #   from:  Rails.application.credentials.twilio_phone_number,
    #   to:    phone_number,
    #   body:  code
    # )
  end
  def self.send(phone_number, message)
    # puts "yess++++++++++++++++++++++++++++++++++++++++++#{phone_number}++++#{message}"
    account_sid =  Rails.application.credentials.twilio_account_sid
    auth_token  =  Rails.application.credentials.twilio_auth_token
    client = Twilio::REST::Client.new(account_sid, auth_token)

    # message = client.messages.create(
    #   from:  Rails.application.credentials.twilio_phone_number,
    #   to:    phone_number,
    #   body:  message
    # )
  end
end
