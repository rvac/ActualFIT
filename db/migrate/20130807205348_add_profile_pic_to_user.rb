class AddProfilePicToUser < ActiveRecord::Migration
  def up
    add_column :users, :profile_picture, :binary, limit: 250.kilobytes
    add_column :users, :content_type, :string
  end

  def down
    remove_column :users, :profile_picture
    remove_column :users, :content_type
  end
end
