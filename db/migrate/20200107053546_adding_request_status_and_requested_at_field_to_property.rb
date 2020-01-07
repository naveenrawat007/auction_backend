class AddingRequestStatusAndRequestedAtFieldToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :requested_status, :string
    add_column :properties, :requested_at, :datetime
  end
end
