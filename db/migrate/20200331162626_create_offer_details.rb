class CreateOfferDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :offer_details do |t|
      t.string :user_first_name
      t.string :user_middle_name
      t.string :user_last_name
      t.string :user_email
      t.string :user_phone_no, :string
      t.boolean :self_buy_property, default: false
      t.string :realtor_first_name
      t.string :realtor_last_name
      t.string :realtor_license
      t.string :realtor_company
      t.string :realtor_phone_no
      t.string :realtor_email
      t.string :purchase_property_as
      t.float :internet_transaction_fee
      t.float :total_due
      t.string :promo_code
      t.datetime :property_closing_date
      t.integer :hold_bid_days
      t.bigint :offer_id
      t.string :offer_type
      t.timestamps
    end
  end
end
