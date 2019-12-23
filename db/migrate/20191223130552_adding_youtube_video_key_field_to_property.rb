class AddingYoutubeVideoKeyFieldToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :youtube_video_key, :string
  end
end
