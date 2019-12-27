class AddingUniqueAddressToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :unique_address, :string
  end
end
