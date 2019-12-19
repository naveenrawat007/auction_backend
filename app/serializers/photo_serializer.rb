class PhotoSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:url] = APP_CONFIG['backend_site_url'] + object.image.url
    data[:name] = object.image_file_name
    data
  end
end
