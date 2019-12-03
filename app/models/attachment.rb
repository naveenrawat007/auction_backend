class Attachment < ApplicationRecord
  has_attached_file :file
  belongs_to :resource, polymorphic: true, optional: true
  do_not_validate_attachment_file_type :file
end
