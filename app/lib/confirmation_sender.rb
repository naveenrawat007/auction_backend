class ConfirmationSender
  def self.send_confirmation_to(user)
    code = CodeGenerator.generate
    user.update(verification_code: code)
    begin
      Sidekiq::Client.enqueue_to_in("default", Time.now, UserVerificationWorker, user.id)
      # c = Geocoder.search(ip_address).first.country unless ip_address.blank?
      # if c
      #   c_details = ISO3166::Country.new(c)
      #   @country_code = c_details.data["country_code"]
      # else
      #   @country_code = "91"
      # end
      #MessageSender.send_code("+91#{user.phone_number}", verification_code)
      @country_code = "1"
      verification_code = "Welcome to Auction my deal. Here is your verification code: #{user.verification_code} "
      MessageSender.send_code("+#{@country_code.to_i}#{user.phone_number}", verification_code)
    rescue StandardError => e
    end
  end
end
