class AddRoleToParticipation < ActiveRecord::Migration
  def up
    add_column :participations, :role, :string
  end

  def down
    remove_column :participations, :role
  end
end
