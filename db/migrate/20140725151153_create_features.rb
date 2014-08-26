class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :meeting_room_id
      t.integer :service_id

      t.timestamps
    end
  end
end
