class AddingPostAuctionWorkerJobIdToPropertropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :post_auction_worker_jid, :string
  end
end
