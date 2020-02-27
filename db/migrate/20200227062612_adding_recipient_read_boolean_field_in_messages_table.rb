class AddingRecipientReadBooleanFieldInMessagesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :recipient_read, :boolean, default: false
  end
end
