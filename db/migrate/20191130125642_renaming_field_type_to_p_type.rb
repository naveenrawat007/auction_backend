class RenamingFieldTypeToPType < ActiveRecord::Migration[5.2]
  def change
    rename_column :properties, :type, :p_type
  end
end
