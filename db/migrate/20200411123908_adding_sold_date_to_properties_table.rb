class AddingSoldDateToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :sold_date, :datetime
  end
end
