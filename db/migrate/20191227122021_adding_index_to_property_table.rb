class AddingIndexToPropertyTable < ActiveRecord::Migration[5.2]
  def change
    add_index :properties, :unique_address, unique: true 
  end
end
