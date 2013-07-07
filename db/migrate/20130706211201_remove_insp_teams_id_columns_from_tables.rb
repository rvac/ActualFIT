class RemoveInspTeamsIdColumnsFromTables < ActiveRecord::Migration
  def up
    remove_column :inspections, :inspection_team_id
    remove_column :users, :inspection_team_id
  end

  def down
    add_column :inspections, :inspection_team_id, :integer
    add_column :users, :inspection_team_id, :integer
  end
end
