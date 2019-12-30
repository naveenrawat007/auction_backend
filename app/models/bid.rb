class Bid < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_many :fund_proofs, as: :resource, class_name: "Attachment"
end
