class AddingTerminationDateAndReasonFieldToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :termination_date, :datetime
    add_column :properties, :termination_reason, :string
  end
end
