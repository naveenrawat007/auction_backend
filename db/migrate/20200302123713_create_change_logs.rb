class CreateChangeLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :change_logs do |t|

      t.timestamps
    end
  end
end
