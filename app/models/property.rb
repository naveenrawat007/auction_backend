class Property < ApplicationRecord
  has_one :change_log
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :photos, as: :imageable, dependent: :destroy
  has_many :videos, as: :resource, dependent: :destroy
  has_one :landlord_deal, dependent: :destroy
  belongs_to :show_instructions_type, optional: true
  belongs_to :seller_pay_type, optional: true
  has_many :bids, dependent: :destroy
  has_many :best_offers, dependent: :destroy

  has_many :buy_nows, -> { where(best_offer: false) }, class_name: "BuyNowOffer"
  has_many :best_buy_nows, -> { where(best_offer: true) }, class_name: "BuyNowOffer"
  has_many :buy_now_offers, dependent: :destroy
  has_many :arv_proofs, -> { where(name: "Arv Proof") }, as: :resource, class_name: "Attachment", dependent: :destroy
  has_many :rehab_cost_proofs, -> { where(name: "Rehab Cost Proof") }, as: :resource, class_name: "Attachment", dependent: :destroy
  has_many :rental_proofs, -> { where(name: "Rental Proof") }, as: :resource, class_name: "Attachment", dependent: :destroy
  geocoded_by :address, latitude: :lat, longitude: :long
  after_validation :geocode, if: ->(obj){ obj.lat.blank? or obj.long.blank? }
  has_many :chat_rooms, dependent: :destroy

  after_create :generate_unique_address
  has_many :user_watch_properties, dependent: :destroy

  has_one :sold_property_record, class_name: "SoldProperty", foreign_key: "property_id", dependent: :destroy
  has_one :property_buyer, through: :sold_property_record, source: :buyer

  has_many :activites, as: :resource, dependent: :destroy

  def generate_unique_address
    if self.address.blank? == false
      self.unique_address = self.address.strip.split(/\W/).join("_") + "_#{self.id}"
    else
      self.unique_address = "porperty_address_" + "#{self.id}"
    end
  end
  def self.category
    ['Residential', 'Commercial', 'Land']
  end

  def self.residential_type
    ['Single Family', 'TownHomes / Condos', 'Multi Family']
  end

  def self.commercial_type
     ['Apartments', 'Retail', 'Industrial', 'Office Building']
  end

  def self.land_type
     ['Residential', 'Commercial', 'Industrial']
  end
  def self.deal_analysis_type
     ['Rehab & Flip Deal', 'Landlord Deal']
  end

  def self.best_offer_length
     [3,5,7,10,14]
  end

  def self.auction_length
     [3,5,7,10]
  end

  def self.buy_option
    ["Cash", "Line of Credit", "Owner Finance", "Hard Money", "Convential Loan", "Rehab Loan"]
  end

  def self.status
    ["Draft", "Under Review", "Hold", "Approve", "Live Online Bidding", "Post Auction", "Pending", "Terminated", "Sold"]
  end

  def self.title_status
    ["Clear title verified", "Clear title not verified but open", "Title not verified or open"]
  end

  def self.owner_category
    ["Owner", "Wholesaler", "Realtor"]
  end

  def self.termination_reason
    ["Title Issue can't get cleared", "Seller backed out of contract", "Sold to Outside Buyer", "Decided to keep property", "Legal issues can't get resolved"]
  end

  def self.withdraw_reason
    ["Edit Property listing", "Need to resolve title issues", "Getting extension from owner", "Getting needed repairs completed", "Setting up open house so buyers can inspect property", "Need to make changes before selling", "Need time before live online auction starts"]
  end
  def self.request_status
    ["Terminated", "Withdraw / Draft"]
  end

  def self.approve_time_delay
    24.hours
  end

  def highest_bid
    if self.bids.blank? == false
      self.bids.maximum(:amount)
    else
      self.seller_price ? seller_price : ""
    end
  end

  def best_offer_price
    if self.best_offer
      if self.best_offers.blank? == false
        self.best_offers.maximum(:amount)
      else
        self.best_offer_sellers_minimum_price
      end
    else
      ""
    end
  end
end
