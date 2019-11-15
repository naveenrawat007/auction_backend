class AddingFieldsToUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :company_name, :string
    add_column :users, :company_phone, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :broker_licence, :string
    add_column :users, :realtor_licence, :string
    add_column :users, :auth_token, :string
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :type_attributes, :json
  end
end
