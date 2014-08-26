class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.integer :user_id
      t.integer :meeting_room_id
      t.string :priority
      t.string :status
      t.text :comment

      t.timestamps
    end
    add_index :bookings, [:user_id,:created_at]
    add_index :bookings, [:meeting_room_id,:created_at]
  end
end
