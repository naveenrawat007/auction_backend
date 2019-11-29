class ChangesInPropertiesTableFields < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :stores, :integer
    add_column :properties, :cap_rates, :decimal, {:precision=>12, :scale=>2}
    add_column :properties, :pay_type, :string
    rename_column :properties, :ms_available, :mls_available
    add_column :properties, :title_status, :string
  end
end
