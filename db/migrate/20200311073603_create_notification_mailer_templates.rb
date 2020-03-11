class CreateNotificationMailerTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_mailer_templates do |t|
      t.text :body
      t.string :path
      t.string :locale
      t.string :handler
      t.boolean :partial, default: false
      t.string :format
      t.string :subject
      t.string :code

      t.timestamps
    end
  end
end
