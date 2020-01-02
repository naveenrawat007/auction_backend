class CreateBestOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :best_offers do |t|

      t.timestamps
    end
  end
end
