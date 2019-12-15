class AddingResourcePolymophismToVideo < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :resource_id, :integer
    add_column :videos, :resource_type, :string
    add_index :videos, [:resource_type, :resource_id]
  end
end
