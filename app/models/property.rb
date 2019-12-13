class Property < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :photos, as: :imageable
  has_one :landlord_deal
  belongs_to :show_instructions_type, optional: true
  belongs_to :seller_pay_type, optional: true

  has_many :arv_proofs, -> { where(name: "Arv Proof") }, as: :resource, class_name: "Attachment"
  has_many :rehab_cost_proofs, -> { where(name: "Rehab Cost Proof") }, as: :resource, class_name: "Attachment"
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

  def self.auction_length
     [7,14,21,28]
  end

  def self.buy_option
    ["Cash", "Line of Credit", "Owner Finance", "Hard Money", "Convential Loan", "Rehab Loan"]
  end

  def self.status
    ["Draft", "Under Review", "Hold", "Approve / Best Offer", "Live Online Bidding", "Post Auction", "Pending", "Terminated", "Sold"]
  end

  def self.title_status
    ["Clear title verified", "Clear title not verified but open", "Title not verified but open"]
  end

  def self.owner_category
    ["Owner", "Wholesaler", "Realtor"]
  end

end
