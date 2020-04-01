class OfferDetail < ApplicationRecord
  belongs_to :offer, polymorphic: true, optional: true
end
