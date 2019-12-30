class AddingFieldsToBidsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :amount, :float
    add_column :bids, :accepted, :boolean, default: false
    add_reference :bids, :property
    add_reference :bids, :user
  end
end
