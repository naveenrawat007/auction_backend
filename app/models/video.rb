class Video < ApplicationRecord
  has_attached_file :video, :styles => {:thumb => ["400x400", :jpg]}, :processors => [:transcoder]
  validates_attachment_content_type :video, :content_type => /\Avideo\/.*\Z/ #['video/mp4']
  belongs_to :resource, polymorphic: true
end
