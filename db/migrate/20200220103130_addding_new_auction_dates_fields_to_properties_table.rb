class AdddingNewAuctionDatesFieldsToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :auction_bidding_ending_at, :datetime
    add_column :properties, :best_offer_auction_started_at, :datetime
    add_column :properties, :best_offer_auction_ending_at, :datetime
  end
end
