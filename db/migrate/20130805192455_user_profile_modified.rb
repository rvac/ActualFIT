class UserProfileModified < ActiveRecord::Migration
  def up
    add_column :users, :skype, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :additional_info, :string

    add_column :campaigns, :status, :string

  end

  def down
    remove_column :users, :skype
    remove_column :users, :address
    remove_column :users, :additional_info
    remove_column :users, :phone
    remove_column :campaigns, :status
  end
end
