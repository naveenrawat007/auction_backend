class CreateNotificationMessageTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_message_templates do |t|

      t.timestamps
    end
  end
end
