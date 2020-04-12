class ChangeLogSerializer < ActiveModel::Serializer
  def attributes(*args)
    data = super
    data[:id] = object.id
    data[:details] = object.details
    data[:created_at] = object.created_at.strftime("%m/%d/%Y")
    data[:images] = property_images
    data[:video_url] = get_video_url
    data
  end
  def get_video_url
    if object.videos.blank? == false
      APP_CONFIG['backend_site_url'] + object.videos.first.video.url
    else
      ""
    end
  end

  def property_images
    object.photos.order(:created_at).map{|i| APP_CONFIG['backend_site_url'] + i.image.url}
  end
end
