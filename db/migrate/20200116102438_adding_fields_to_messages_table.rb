class AddingFieldsToMessagesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :content, :string
    add_reference :messages, :user
    add_reference :messages, :group
  end
end
