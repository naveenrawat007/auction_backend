class AddingFieldsToShowInstructionsTypesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :show_instructions_types, :name, :string
    add_column :show_instructions_types, :description, :string
  end
end
