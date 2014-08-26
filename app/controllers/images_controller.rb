class ImagesController < ApplicationController
  include Rails.application.routes.url_helpers
  
  def index
      @images = Image.all
      puts "To json #{@images.collect { |p| p.to_jq_upload }.to_json}"
      render :json => @images.collect { |p| p.to_jq_upload }.to_json
    end
    
    def new
      @meeting_room = MeetingRoom.new
      @images=@meeting_room.images.build
      puts "images #{@images}"
    end
    

    def create
      p_attr = params[:image]
      p_attr[:file] = params[:image][:file].first if params[:image][:file].class == Array

      @image = Image.new(p_attr)
      if @image.save
        respond_to do |format|
          format.html {  
            render :json => [@image.to_jq_upload].to_json, 
            :content_type => 'text/html',
            :layout => false
          }
          format.json {  
            render :json => { :files => [@image.to_jq_upload] }         
          }
        end
      else 
        render :json => [{:error => "custom_failure"}], :status => 304
      end
    end

    def destroy
      @image = Image.find(params[:id])
      @image.destroy
      render :json => true
    end
    
end