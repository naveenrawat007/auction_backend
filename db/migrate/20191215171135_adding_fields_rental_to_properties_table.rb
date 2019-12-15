class AddingFieldsRentalToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :rental_description, :string
  end
end
