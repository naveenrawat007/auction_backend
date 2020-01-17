class RenamingTablesAndFieldsRelatedToChatSystem < ActiveRecord::Migration[5.2]
  def change
    remove_reference :user_groups, :group
    remove_reference :messages, :group
    rename_table :groups, :chat_rooms
    rename_table :user_groups, :user_chat_rooms
    add_reference :user_chat_rooms, :chat_room
    add_reference :messages, :chat_room
  end
end
