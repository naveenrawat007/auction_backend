class PropertyUnderReviewWorker
  include Sidekiq::Worker
  sidekiq_options retry: 4

  def perform(user_id, property_id)
    property = Property.find_by(id: property_id)
    user = User.find_by(id: user_id)
    if property && user
      PropertyMailer.under_review(user.id, property.id).deliver
    end
  end
end
