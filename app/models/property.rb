class Property < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :photos, as: :imageable

  def self.category
    ['Residential', 'Commercial', 'Land']
  end

  def self.type
    ['Single Family', 'TownHomes / Condos', 'Multi Family', 'Apartments', 'Retail', 'Industrial', 'Office Building', 'Residential', 'Commercial', 'Industrial']
  end
end
