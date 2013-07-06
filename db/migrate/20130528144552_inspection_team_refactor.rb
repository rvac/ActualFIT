class InspectionTeamRefactor < ActiveRecord::Migration
  def up
    rename_table :inspection_teams, :participations
  end

  def down
    rename_table :participations, :inspection_teams
  end
end
