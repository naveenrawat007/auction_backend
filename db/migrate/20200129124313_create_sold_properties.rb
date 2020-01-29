class CreateSoldProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :sold_properties do |t|

      t.timestamps
    end
  end
end
