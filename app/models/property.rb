class Property < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :photos, as: :imageable

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
end
