class Booking < ActiveRecord::Base
  MAX_RESERVATION_TIME = 10800
  MIN_RESERVATION_TIME = 1800
  has_many :attendees, dependent: :destroy
  accepts_nested_attributes_for :attendees#, reject_if: proc { |p| p['booking_id'].nil? } , allow_destroy: true
  belongs_to :user
  belongs_to :meeting_room
  default_scope -> { order('created_at DESC') }
  validates :title, presence: true, length: { maximum: 50 }
  validates :user_id, presence: true
  validates :meeting_room_id, presence: true
  validates :priority, presence: true, inclusion: { in: %w(low medium high),
                                       message: "%{value} is not valid" }
  validates :status, presence: true, inclusion: { in: %w(ongoing waiting finished canceled updated),
                                       message: "%{value} is not valid" }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :date_availability, :check_attendees_number
  
  private
  
  def date_availability
    unless start_date.nil? && end_date.nil?
      ##Checks if one of the dates day is saturday or sunday
      if start_date.saturday? || end_date.saturday? || start_date.sunday? || end_date.sunday?
        errors[:base]<< "Cannot make bookings on saturdays or sundays"
      ##Checks if the minimum or maximum reservation time is the correct one
      elsif ((end_date - start_date) > MAX_RESERVATION_TIME || (end_date - start_date) < MIN_RESERVATION_TIME)
        errors[:base]<< "Bookings can only last a maximum of 3 hours or a minimum of 30 minutes"
      ##Cheks if those dates are available
      elsif !Booking.where('((start_date BETWEEN :start_date AND :end_date) AND meeting_room_id = :meeting_room_id) OR ((end_date BETWEEN :start_date AND :end_date) AND meeting_room_id = :meeting_room_id) OR (start_date >= :start_date AND end_date <= :end_date AND meeting_room_id = :meeting_room_id)', start_date: start_date, end_date: end_date, meeting_room_id: meeting_room_id).empty?
        errors[:base]<< "Date is not available"
      end
    end
  end
  
  def check_attendees_number
    errors.add(:attendees, "should have at least one person #{attendees.count}") if attendees_empty?
  end
  
  def attendees_empty?
      attendees.empty? or attendees.all? {|attendee| attendee.marked_for_destruction? }
  end
  
  def self.find_by_date_bookings(my_date)
    bookings = Booking.where("DATE(start_date) = ?", my_date.to_date)
    self.bookings_found(bookings)
  end
  
  def self.get_all_bookings
    bookings = self.all
    self.bookings_found(bookings)
  end
  
  def self.find_by_meeting_room(meeting_room_id)
    bookings = Booking.where("meeting_room_id = ? ",meeting_room_id)
    self.booking_found(bookings)
  end
  
  def self.find_user_bookings(user_id)
    bookings = Booking.where("user_id = ?",user_id)
    self.bookings_found(bookings)
  end
  
  def self.find_by_date_and_meeting_room(my_date,meeting_room_id)
    bookings = Booking.where("DATE(start_date) = ? AND meeting_room_id = ?",my_date.to_date,meeting_room_id)
    self.bookings_found(bookings)
  end
  
  def self.bookings_found(bookings)
    bookings_found = []
    bookings.each do |booking| 
      bookings_found << {
        id: booking.id,
        title: booking.title,
        start_date: booking.start_date,
        end_date: booking.end_date,
        priority: booking.priority,
        status: booking.status,
        comment: booking.comment,
        user_id: booking.user.id,
        owner: booking.user.full_name,
        attendees: booking.attendees
      }
    end
    bookings_found
  end
end

