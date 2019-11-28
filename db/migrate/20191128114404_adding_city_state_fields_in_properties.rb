class AddingCityStateFieldsInProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :city, :string
    add_column :properties, :state, :string
  end
end
