class AttachmentSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:file_name] = object.file_file_name
    data[:file_url] = APP_CONFIG['backend_site_url'] + object.file.url
    data[:file_content_type] = object.file_content_type
    data[:created_at] = object.created_at.strftime("%I:%M %p")
    data
  end
end
