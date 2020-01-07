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

  def live_bidding(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property is Live for online bidding.")
    end
  end

  def status_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property status is changed to #{@property.status}")
    end
  end

  def best_offer_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Offer recieved for #{@property.address}")
    end
  end
  def bid_notification(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Bid recieved for #{@property.address}")
    end
  end

  def best_offer(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Your Property is Open for accepting Offers.")
    end
  end
  def post_auction(user_id, property_id)
    @user = User.find_by(id: user_id)
    @property = Property.find_by(id: property_id)
    if @user && @property
      mail(to: [@user.email], subject: "Property's auction period is over.")
    end
  end
  def share_link(email, link)
    @link = link
    mail(to: [email], subject: "Property is Shared.")
  end
end
