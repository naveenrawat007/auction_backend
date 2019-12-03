class AddingPropertyIdToLandlordDeals < ActiveRecord::Migration[5.2]
  def change
    add_reference :landlord_deals, :property
  end
end
