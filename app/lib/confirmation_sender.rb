class ConfirmationSender
  def self.send_confirmation_to(user)
    code = CodeGenerator.generate
    user.update(verification_code: code)
    begin
      Sidekiq::Client.enqueue_to_in("default", Time.now, UserVerificationWorker, user.id)
    rescue StandardError => e
    end
  end
end
