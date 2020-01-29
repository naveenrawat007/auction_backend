class SoldProperty < ApplicationRecord
  belongs_to :property, class_name: "Property", foreign_key: "property_id"
  belongs_to :buyer, class_name: "User", foreign_key: "user_id"
  belongs_to :offer, polymorphic: true
end
