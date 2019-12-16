class RenamingOwnerCategryField < ActiveRecord::Migration[5.2]
  def change
    rename_column :properties, :owner_categogry, :owner_category
    rename_column :properties, :best_offer_lenght, :best_offer_length
  end
end
