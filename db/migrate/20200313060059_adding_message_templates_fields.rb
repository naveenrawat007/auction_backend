class AddingMessageTemplatesFields < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_message_templates, :path, :string
    add_column :notification_message_templates, :body, :string
    add_column :notification_message_templates, :code, :string
    add_column :notification_message_templates, :title, :string
  end
end
