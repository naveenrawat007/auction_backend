class AddingFieldSubmittedBooleanToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :submitted, :boolean, default: false
  end
end
