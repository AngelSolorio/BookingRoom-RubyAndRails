class AddMissingFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo_file, :string
    add_column :users, :title, :string
    add_column :users, :department, :string
    add_column :users, :company, :string
    add_column :users, :full_name, :string
  end
end
