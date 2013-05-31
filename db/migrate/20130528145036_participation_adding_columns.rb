class ParticipationAddingColumns < ActiveRecord::Migration
  def up
    add_column :participations, :inspection_id, :integer
    remove_column :participations, :name
  end

  def down
    remove_column :participations, :inspection_id
    add_column :participations, :name, :string
  end
end
