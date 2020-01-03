class CreateBuyNowOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :buy_now_offers do |t|

      t.timestamps
    end
  end
end
