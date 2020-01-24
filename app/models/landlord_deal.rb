class LandlordDeal < ApplicationRecord
  belongs_to :property
  audited associated_with: :property
end
