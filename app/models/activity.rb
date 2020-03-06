class Activity < ApplicationRecord
  belongs_to :resource, polymorphic: true

  act_type = ["user_login", "user_register", "user_password_change", "property_posted", "bid_submission", "offer_submission", "buy_now_submission", "request_for_termination"]

  def resource_name
    if act_type == "user_login"
      return resource.first_name
    elsif act_type == "user_register"
      return resource.first_name
    elsif act_type == "user_password_change"
      return resource.first_name
    elsif act_type == "property_posted"
      return resource.owner.first_name
    elsif act_type == "bid_submission"
      return resource.user.first_name
    elsif act_type == "offer_submission"
      return resource.user.first_name
    elsif act_type == "buy_now_submission"
      return resource.user.first_name
    elsif act_type == "request_for_termination"
      return resource.owner.first_name
    end
  end

  def description
    if act_type == "user_login"
      return "Login to the site"
    elsif act_type == "user_register"
      return "New registration on site"
    elsif act_type == "user_password_change"
      return "Updated Password"
    elsif act_type == "property_posted"
      return "Posted a property at #{resource.address}"
    elsif act_type == "bid_submission"
      return "Submitted a bid at #{resource.property.address}"
    elsif act_type == "offer_submission"
      return "Submitted a Best Offer at #{resource.property.address}"
    elsif act_type == "buy_now_submission"
      return "Submitted a Buy Now at #{resource.property.address}"
    elsif act_type == "request_for_termination"
      return "Submitted Termination Request at #{resource.address}"
    end
  end
end
