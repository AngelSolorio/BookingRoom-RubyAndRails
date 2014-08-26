class MeetingRoomsController < ApplicationController
  respond_to :html, only: [:new,:create]
  include ErrorCode
  skip_before_action :verify_authenticity_token
  before_action :restrict_access, only: [:index, :new, :create]
  
  def index
    @meeting_rooms=MeetingRoom.all
    
    respond_to do |format|
      format.html
      format.json { 
        @meetings=[]
        @meeting_rooms.each do |meeting_room|
          @meetings<< {
            id: meeting_room.id,
            name: meeting_room.name,
            capacity: meeting_room.capacity,
            location: meeting_room.location,
            images: meeting_room.images
          }
        end
          
        render :json=>{ meeting_rooms: @meetings,
                              success:  true
                           } , status: 200 }
    end
  end
  
  def new
     @meeting_room = MeetingRoom.new
     @meeting_room_images=@meeting_room.images.build
     @services=Service.all     
  end
  
  def show
    @meeting_room= MeetingRoom.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { 
        
        @services=[]
        @meeting_room.services.each do |service|
          @services<< {
            id: service.id,
            name: service.name,
            image: service.photo_file
          }
        end
    
        render :json=>{ meeting_room: {
                                        id: @meeting_room.id,
                                        name: @meeting_room.name,
                                        location: @meeting_room.location,
                                        capacity: @meeting_room.capacity,
                                        services: @services,
                                        images: @meeting_room.images
                                      },
                             success:  true
                          } , status: 200 }
  end
end
  
  def create
    @meeting_room = MeetingRoom.new(meeting_room_params)
        params[:meeting_room][:images_attributes].each { |x,y| @meeting_room_image = @meeting_room.images.build(:photo_file => y) } if !params[:meeting_room][:images_attributes].nil?
        if @meeting_room.save          
          respond_to do |format|
          format.html { redirect_to @meeting_room, notice: 'Meeting Room was successfully created.' }
        end
      else
        puts "Errors in saving a meeting room #{@meeting_room.errors.full_messages}"
        respond_to do |format|
          format.html { redirect_to new_meeting_room_path }
          format.json { render :json=>{ message: @meeting_room.errors.full_messages,
                                        error_code: ErrorCode::MEETING_ROOM_VALIDATION
                                      } , status: :unprocessable_entity }
        end
      end
  end
  
  private
  
  def meeting_room_params
    params.require(:meeting_room).permit(:name,:capacity,:location,images_attributes: [:photo_file,:id,:meeting_room_id],service_ids:[])
  end
  
end
