class AddingColumnTrialEndingAtToUsersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :trial_ending_at, :datetime
  end
end
