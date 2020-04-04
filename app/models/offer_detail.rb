class OfferDetail < ApplicationRecord
  belongs_to :offer, polymorphic: true, optional: true
  has_many :business_documents, as: :resource, class_name: "Attachment", dependent: :destroy
end
