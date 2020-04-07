class Addpropertyclosingamountcolumn < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :property_closing_amount, :float
  end
end
