class AddingFieldsToSoldPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_reference :sold_properties, :user
    add_reference :sold_properties, :property
    add_column :sold_properties, :offer_id, :integer
    add_column :sold_properties, :offer_type, :string
    add_index :sold_properties, [:offer_type, :offer_id]
  end
end
