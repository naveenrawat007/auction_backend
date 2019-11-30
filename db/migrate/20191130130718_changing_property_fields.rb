class ChangingPropertyFields < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :zip_code, :string
    remove_column :properties, :area
    remove_column :properties, :lot_size
    add_column :properties, :area, :float
    add_column :properties, :lot_size, :float
  end
end
