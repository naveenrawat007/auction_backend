class AddingPropertyReferenceToChatRoom < ActiveRecord::Migration[5.2]
  def change
    add_reference :chat_rooms, :property
  end
end
