class AddingFieldsToUserGroupsTable < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_groups, :user
    add_reference :user_groups, :group 
  end
end
