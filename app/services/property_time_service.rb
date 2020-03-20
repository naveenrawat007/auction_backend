class PropertyTimeService
  include ApplicationHelper
  attr_reader :property

  def initialize(property)
    @property = property
 	end

  def set_property_timing_admin
    if property.best_offer == true
      if property.best_offer_auction_started_at.blank? == false
        property.best_offer_auction_started_at = property.best_offer_auction_started_at.beginning_of_day + 8.hours
        best_offer_live_auction(property)
      end
      if property.best_offer_auction_ending_at.blank? == false
        property.best_offer_auction_ending_at = property.best_offer_auction_ending_at.end_of_day - 4.hours
        property.auction_started_at = (property.best_offer_auction_ending_at + 1.day).beginning_of_day + 8.hours
        property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
        best_offer_post_auction(property)
      end
    end
    if property.auction_started_at.blank? == false
      property.auction_started_at = property.auction_started_at.beginning_of_day + 8.hours
      property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
    end
    if property.auction_bidding_ending_at == false || property.auction_length.blank? == false
      property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
    end
    if property.auction_ending_at.blank? == false
      if property.auction_ending_at.to_i != property.auction_ending_at.end_of_day.to_i
        property.auction_ending_at = property.auction_ending_at.end_of_day
      end
    end
    live_auction(property)
    post_auction(property)
    return property
  end

  def set_property_timing
    if property.best_offer == true
      if property.best_offer_auction_started_at.blank? == false
        property.best_offer_auction_started_at = property.best_offer_auction_started_at.beginning_of_day + 8.hours
      end
      if property.best_offer_auction_ending_at.blank? == false
        property.best_offer_auction_ending_at = property.best_offer_auction_ending_at.end_of_day - 4.hours
        property.auction_started_at = (property.best_offer_auction_ending_at + 1.day).beginning_of_day + 8.hours
        property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
      end
    end
    if property.auction_started_at.blank? == false
      property.auction_started_at = property.auction_started_at.beginning_of_day + 8.hours
      property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
    end
    if property.auction_bidding_ending_at == false || property.auction_length.blank? == false
      property.auction_bidding_ending_at = (property.auction_started_at + property.auction_length.to_i.days).beginning_of_day - 4.hours
    end
    if property.auction_ending_at.blank? == false
      if property.auction_ending_at.to_i != property.auction_ending_at.end_of_day.to_i
        property.auction_ending_at = property.auction_ending_at.end_of_day
      end
    end
    return property
  end
end
