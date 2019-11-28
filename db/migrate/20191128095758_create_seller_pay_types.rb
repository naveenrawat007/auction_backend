class CreateSellerPayTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :seller_pay_types do |t|

      t.timestamps
    end
  end
end
