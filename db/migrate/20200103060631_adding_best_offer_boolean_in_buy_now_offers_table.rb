class AddingBestOfferBooleanInBuyNowOffersTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :buy_now_offers, :type
    add_column :buy_now_offers, :best_offer, :boolean, default: false
  end
end
