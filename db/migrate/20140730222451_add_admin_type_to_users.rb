class AddAdminTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_type, :string, default: 'none'
  end
end
