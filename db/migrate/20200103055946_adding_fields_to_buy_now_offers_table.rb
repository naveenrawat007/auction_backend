class AddingFieldsToBuyNowOffersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :buy_now_offers, :amount, :float
    add_column :buy_now_offers, :accepted, :boolean, default: false
    add_column :buy_now_offers, :type, :string
    add_reference :buy_now_offers, :property
    add_reference :buy_now_offers, :user
  end
end
