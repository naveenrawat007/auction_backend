class AddingMailTypeFieldToNotificationMailerTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_mailer_templates, :mail_type, :string
  end
end
