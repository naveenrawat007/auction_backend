class RenamedPaytypeToBuyOptions < ActiveRecord::Migration[5.2]
  def change
    remove_column :properties, :pay_type
    add_column :properties, :buy_option, :json
  end
end
