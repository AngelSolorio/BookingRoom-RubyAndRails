class Image < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :meeting_room
  mount_uploader :photo_file, PhotoFileUploader
  validates :photo_file, presence: true
  
  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:photo_file),
      "size" => photo_file.size,
      "url" => photo_file.url,
      "thumbnail_url" => photo_file.thumb.url,
      "delete_url" => image_path(:id => id),
      "delete_type" => "DELETE" 
    }
  end
end
