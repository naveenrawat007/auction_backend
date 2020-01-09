class AddingColumnBuyNowOptionJsonBiddingTables < ActiveRecord::Migration[5.2]
  def change
    add_column :bids, :buy_option, :json
    add_column :best_offers, :buy_option, :json
    add_column :buy_now_offers, :buy_option, :json
  end
end
