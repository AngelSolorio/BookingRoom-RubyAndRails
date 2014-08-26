class BookingsController < ApplicationController
  include ErrorCode
  skip_before_action :verify_authenticity_token
  before_action :correct_user, only: :destroy
  before_action :restrict_access, only: [:index,:new,:create,:destroy]
  
  def index
    search[:datetime] = DateTime.strptime(search[:datetime],"%Y-%m-%d %H:%M:%S %z") unless params[:datetime].nil?
    search[:meeting_room_id] = params[:search][:meeting_room_id] unless params[:meeting_room_id].nil?
    searching_by_date_and_meeting_room = !params[:datetime].nil? && !params[:meeting_room_id].nil?
    searching_by_date = !params[:datetime].nil? 
    searching_by_meeting_room = !params[:meeting_room_id].nil?
    searching_by_current_user = !params[:current_user].nil? ? !(params[:current_user].to_i).zero? : false
    
    
    if searching_by_date_and_meeting_room
      respond_to do |format|
        format.html
        format.json {  render :json=>{ bookings: Booking.find_by_date_and_meeting_room(params[:datetime],params[:meeting_room_id]),
                                       success:  true
                                     } , status: 200 }
      end 
    elsif searching_by_date
      respond_to do |format|
        format.html
        format.json {  render :json=>{ bookings: Booking.find_by_date_bookings(search[:datetime]),
                                       success:  true
                                     } , status: 200 }
      end 
    elsif searching_by_current_user
      respond_to do |format|
        format.html
        format.json { render :json=> {bookings: Booking.find_user_bookings(current_user),
                                      success: true 
                                      }, status: 200 }
      end
    else     
      respond_to do |format|
        format.html
        format.json {  render :json=>{ bookings: Booking.get_all_bookings,
                                       success:  true
                                     } , status: 200 }
      end  
  end
  
end
  
  def new
    @booking = current_user.bookings.build
    @meeting_rooms = MeetingRoom.all
  end
  
  def create
    @user=current_user
    @booking=@user.bookings.build(booking_params)
    unless params[:booking][:attendees_attributes].nil?
      params[:booking][:attendees_attributes].each do |x,y|
        puts "Attendee"
        @user=User.find_by_email(y['email'])
        if @user #If the user is in the db just add them to the booking attendees
          @booking_attendee = @booking.attendees.build(user_id: y['user_id'], booking_id: y['booking_id']) 
        else #If the user is not in the db, create them first, then add them to the booking attendees
          @user=User.find_for_ldap(y['email'],"email")
          @booking_attendee = @booking.attendees.build(user_id: @user.id, booking_id: y['booking_id']) if @user.persisted?
        end
      end
     end
      
    if @booking.save
      respond_to do |format|
        format.html { redirect_back_or new_booking_path }
        format.json { render :json=>{ booking: @booking,
                                      success:  true,
                                      } , status: 200 }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_booking_path }
        format.json { render :json=>{ message: @booking.errors.full_messages,
                                      error_code: ErrorCode::BOOKING_VALIDATION
                                      } , status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  def update
  end
  
  private
  def booking_params
    params.require(:booking).permit(:title,:start_date,:end_date,:meeting_room_id,:priority,:status,:comment,attendees_attributes: [:id,:booking_id,:user_id])
  end
  
  def correct_user #Checks if the booking belongs to the current user
    @booking = current_user.bookings.find_by(id: params[:id])
    redirect_to root_url if @booking.nil?
  end
  
  def search
    @search = []
  end
end
