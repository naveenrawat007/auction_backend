class AddingFieldsToBestOffersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :best_offers, :amount, :float
    add_column :best_offers, :accepted, :boolean, default: false
    add_reference :best_offers, :property
    add_reference :best_offers, :user
  end
end
