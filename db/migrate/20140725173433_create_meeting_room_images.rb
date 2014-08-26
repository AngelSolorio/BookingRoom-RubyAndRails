class CreateMeetingRoomImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :photo_file
      t.integer :meeting_room_id

      t.timestamps
    end
  end
end
