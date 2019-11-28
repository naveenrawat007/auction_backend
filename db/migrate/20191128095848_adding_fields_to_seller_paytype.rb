class AddingFieldsToSellerPaytype < ActiveRecord::Migration[5.2]
  def change
    add_column :seller_pay_types, :name, :string
    add_column :seller_pay_types, :description, :string
  end
end
