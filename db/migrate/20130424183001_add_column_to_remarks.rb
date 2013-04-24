class AddColumnToRemarks < ActiveRecord::Migration
  def change
  	add_column :remarks, :artifact_id, :integer
  	rename_column :remarks, :remark_type, :type
  end
end
