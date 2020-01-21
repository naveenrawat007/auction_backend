class AddingPolymorphicReferenceInChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_rooms, :offer_id, :integer
    add_column :chat_rooms, :offer_type, :string
    add_index :chat_rooms, [:offer_type, :offer_id]
  end
end
