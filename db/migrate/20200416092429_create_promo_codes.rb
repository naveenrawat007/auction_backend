class CreatePromoCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :promo_codes do |t|
      t.string :promo_code
      t.references :user
      t.index :promo_code
      t.boolean :availed, default: false
      t.timestamps
    end
  end
end
