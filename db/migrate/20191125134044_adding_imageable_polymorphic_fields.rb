class AddingImageablePolymorphicFields < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :imageable_id, :integer
    add_column :photos, :imageable_type, :string
    add_index :photos, [:imageable_type, :imageable_id]
  end
end
