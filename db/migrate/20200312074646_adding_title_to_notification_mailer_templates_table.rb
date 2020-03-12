class AddingTitleToNotificationMailerTemplatesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :notification_mailer_templates, :title, :string
  end
end
