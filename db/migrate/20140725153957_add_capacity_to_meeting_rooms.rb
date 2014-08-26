class AddCapacityToMeetingRooms < ActiveRecord::Migration
  def change
    add_column :meeting_rooms, :capacity, :integer
  end
end
