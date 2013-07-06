class InspectionTeamIdFieldAddedToUserAndInspection < ActiveRecord::Migration
  def up
    add_column :users, :inspection_team_id, :integer
    add_column :inspections, :campaign_id, :integer
    add_column :inspections, :status, :string
  end

  def down
    remove_column :inspections, :status
    remove_column :users, :inspection_team_id
    remove_column :inspections, :campaign_id
  end
end
