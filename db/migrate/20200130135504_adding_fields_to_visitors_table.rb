class AddingFieldsToVisitorsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :visitors, :name, :string
    add_column :visitors, :phone_number, :string
    add_column :visitors, :email, :string
    add_column :visitors, :question, :string
  end
end
