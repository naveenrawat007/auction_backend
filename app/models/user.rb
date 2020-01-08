class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :photo, as: :imageable
  has_many :owned_properties, class_name: "Property", foreign_key: "owner_id"
  has_many :bids
  has_many :bidded_properties, through: :bids, source: :property
  has_many :best_offers
  has_many :best_offered_properties, through: :best_offers, source: :property
  has_many :buy_nows, -> { where(best_offer: false) }, class_name: "BuyNowOffer"
  has_many :best_buy_nows, -> { where(best_offer: true) }, class_name: "BuyNowOffer"
  has_many :buy_now_offers
  has_many :buy_now_offered_properties, through: :buy_now_offers, source: :property

  has_many :user_watch_properties
  has_many :watch_properties, through: :user_watch_properties, source: :property
end
