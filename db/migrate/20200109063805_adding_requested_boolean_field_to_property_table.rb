class AddingRequestedBooleanFieldToPropertyTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :requested, :boolean, default: false
  end
end
