class CreateUserWatchProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :user_watch_properties do |t|

      t.timestamps
    end
  end
end
