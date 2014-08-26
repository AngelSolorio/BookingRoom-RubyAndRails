class MeetingRoom < ActiveRecord::Base
  IMAGES_COUNT_MIN=1
  has_many :features, dependent: :destroy
  has_many :services, through: :features
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images,reject_if: proc { |p| p['photo_file'].nil? } , allow_destroy: true
  validate :check_images_number
  validates :name, presence: true
  validates :capacity, numericality:{ allow_nil: false, 
                       only_integer: true, greater_than_or_equal_to: 1,
                       less_than_or_equal_to: 10, message: "Can only be whole number between 1 and 10." }
  validate :check_services_number

  
  private
  def check_images_number
    errors.add(:images, "Meeting Rooms should have at least one image") if images_empty?
  end
  
  def images_empty?
      images.empty? or images.all? {|image| image.marked_for_destruction? }
  end
  
  def check_services_number
      errors.add(:services, "should have at least one") if services.size ==0
  end
  
end
