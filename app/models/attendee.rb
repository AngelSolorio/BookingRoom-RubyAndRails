class Attendee < ActiveRecord::Base
  belongs_to :booking
  belongs_to :user
  #validates :booking_id, presence: true
  validates :user_id, presence: true
end
