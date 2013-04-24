class AddInspectionteamIdToInspections < ActiveRecord::Migration
  def change
  	add_column :inspections, :inspection_team_id, :integer
  end
end
