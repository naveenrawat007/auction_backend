class ChangingFloodCountDataType < ActiveRecord::Migration[5.2]
  def change
    change_column :properties, :flood_count, :string
  end
end
