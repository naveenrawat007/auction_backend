class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :photo, as: :imageable, dependent: :destroy
  has_many :owned_properties, class_name: "Property", foreign_key: "owner_id", dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :bidded_properties, through: :bids, source: :property
  has_many :best_offers, dependent: :destroy
  has_many :best_offered_properties, through: :best_offers, source: :property
  has_many :buy_nows, -> { where(best_offer: false) }, class_name: "BuyNowOffer"
  has_many :best_buy_nows, -> { where(best_offer: true) }, class_name: "BuyNowOffer"
  has_many :buy_now_offers, dependent: :destroy
  has_many :buy_now_offered_properties, through: :buy_now_offers, source: :property

  has_many :user_watch_properties, dependent: :destroy
  has_many :watch_properties, through: :user_watch_properties, source: :property
  has_many :user_chat_rooms, dependent: :destroy
  has_many :chat_rooms, through: :user_chat_rooms
  # has_many :owned_chat_rooms, through: :owned_properties, source: :chat_rooms
  has_many :messages, dependent: :destroy
  has_many :user_bought_properties, class_name: "SoldProperty", foreign_key: "user_id"
  has_many :bought_properties, through: :user_bought_properties, source: :property
  has_many :activities, as: :resource, dependent: :destroy
  def is_premium?
    if self.status == "Premium"
      true
    else
      if self.trial_ending_at.blank? == true
        false
      else
        if Time.now > self.trial_ending_at
          false
        else
          true
        end
      end
    end
  end

  def full_name
    self.first_name.to_s + " " + self.last_name.to_s
  end

  def user_image
    if self.photo
      APP_CONFIG['backend_site_url'] + self.photo.image.url
    else
      ""
    end
  end

  def self.status
    ['Free', 'Premium', 'Ban']
  end
end
