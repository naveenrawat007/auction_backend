class ChangeLog < ApplicationRecord
  belongs_to :property
  has_many :photos, as: :imageable, dependent: :destroy
  has_many :videos, as: :resource, dependent: :destroy
end
