class AddingRequestReasonFieldToPropertiesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :request_reason, :string
  end
end
