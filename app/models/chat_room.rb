class ChatRoom < ApplicationRecord
  has_many :user_chat_rooms, dependent: :destroy
  has_many :users, through: :user_chat_rooms
  has_many :messages, dependent: :destroy
  belongs_to :property
  delegate :owner, :to => :property, :allow_nil => false
  belongs_to :offer, polymorphic: true
end
