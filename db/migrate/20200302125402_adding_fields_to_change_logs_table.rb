class AddingFieldsToChangeLogsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :change_logs, :details, :json
    add_reference :change_logs, :property
  end
end
