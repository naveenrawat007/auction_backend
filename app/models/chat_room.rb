class ChatRoom < ApplicationRecord
  has_many :user_chat_rooms
  has_many :users, through: :user_chat_rooms
  has_many :messages, dependent: :destroy
  belongs_to :property
end