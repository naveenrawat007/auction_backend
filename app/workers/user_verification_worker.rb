class UserVerificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(user_id)
    user = User.find_by(id: user_id)
    if user
      if user.email.blank? == false
        UserVerificationMailer.verify_code(user).deliver
      end
    end
  end

end
