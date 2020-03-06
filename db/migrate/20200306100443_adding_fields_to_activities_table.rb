class AddingFieldsToActivitiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :viewed, :boolean, default: false
    add_column :activities, :act_type, :string
    add_column :activities, :resource_id, :integer
    add_column :activities, :resource_type, :string
    add_index :activities, [:resource_id, :resource_type]
  end
end
