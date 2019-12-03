class CreateLandlordDeals < ActiveRecord::Migration[5.2]
  def change
    create_table :landlord_deals do |t|

      t.timestamps
    end
  end
end
