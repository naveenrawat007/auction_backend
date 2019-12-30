class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :photo, as: :imageable
  has_many :owned_properties, class_name: "Property", foreign_key: "owner_id"
  has_many :bids
end
