class AddingFieldsToUserWatchPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_watch_properties, :user
    add_reference :user_watch_properties, :property
  end
end
