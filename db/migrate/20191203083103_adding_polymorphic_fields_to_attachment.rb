class AddingPolymorphicFieldsToAttachment < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :resource_id, :integer
    add_column :attachments, :resource_type, :string
    add_index :attachments, [:resource_type, :resource_id]
  end
end
