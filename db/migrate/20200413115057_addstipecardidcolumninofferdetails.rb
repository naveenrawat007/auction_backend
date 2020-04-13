class Addstipecardidcolumninofferdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :offer_details, :stripe_card_id, :string
  end
end
