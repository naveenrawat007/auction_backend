class AddingOpenBooleanToChatRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_rooms, :open_connection, :boolean, default: true
  end
end
