class ChangingFieldsForPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :properties, :bedrooms
    remove_column :properties, :bathrooms
    remove_column :properties, :garage
    remove_column :properties, :year_built
    remove_column :properties, :units
    remove_column :properties, :price_per_sq_ft
    remove_column :properties, :stores
    remove_column :properties, :cap_rates
    remove_column :properties, :area
    remove_column :properties, :lot_size
    add_column :properties, :residential_attributes, :json
    add_column :properties, :commercial_attributes, :json
    add_column :properties, :land_attributes, :json
  end
end
