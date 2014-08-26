class AddLocationToMeetingRooms < ActiveRecord::Migration
  def change
    add_column :meeting_rooms, :location, :string
  end
end
