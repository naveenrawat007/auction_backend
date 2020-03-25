class Photo < ApplicationRecord
  has_attached_file :image, styles: { thumb: ["291x140#", :jpg], original: {convert_options: '-auto-orient'} }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  belongs_to :imageable, polymorphic: true
end
