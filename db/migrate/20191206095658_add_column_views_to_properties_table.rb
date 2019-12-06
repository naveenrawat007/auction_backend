class AddColumnViewsToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :total_views, :integer, default: 0
  end
end
