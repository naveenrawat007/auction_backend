class ConfirmationSender
  def self.send_confirmation_to(user)
    code = CodeGenerator.generate
    user.update(verification_code: code)
    begin
      Sidekiq::Client.enqueue_to_in("default", Time.now, UserVerificationWorker, user.id)
      verification_code = "Please enter the following verification code to activate your account at www.AuctionMyDeal.com.  Verification Code: #{user.verification_code} "
      MessageSender.send_code("+1#{user.phone_number}", verification_code)
    rescue StandardError => e
    end
  end
end
