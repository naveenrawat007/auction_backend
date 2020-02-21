class AddingWorkerIdsToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :best_offer_post_auction_worker_jid, :string
    add_column :properties, :best_offer_live_auction_worker_jid, :string
    add_column :properties, :live_auction_worker_jid, :string
  end
end
