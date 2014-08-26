class Service < ActiveRecord::Base
  validates :name, presence: true
  has_many :features
  has_many :meeting_rooms, through: :features
  mount_uploader :photo_file, IconUploader
end
