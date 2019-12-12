class AddingSubmittedTimeToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :submitted_at, :datetime
  end
end
