class PropertyMailer < ApplicationMailer
  def under_review(user_id, property_id)
	  @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property is Submitted for review.")
    end
	end

  def approved(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property is approved for bidding.")
    end
  end
end