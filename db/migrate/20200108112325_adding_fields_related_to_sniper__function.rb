class AddingFieldsRelatedToSniperFunction < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :sniper, :boolean, default: false
    add_column :properties, :sniper_length, :integer, default: 0
  end
end
