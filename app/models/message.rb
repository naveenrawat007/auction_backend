class Message < ApplicationRecord
  after_create_commit { MessageBroadcastWorker.perform_at(Time.now, self.id) }
  belongs_to :chat_room
  belongs_to :user
  has_many :attachments, as: :resource, dependent: :destroy 
end
