class AddPhotoFileToServices < ActiveRecord::Migration
  def change
    add_column :services, :photo_file, :string
  end
end
