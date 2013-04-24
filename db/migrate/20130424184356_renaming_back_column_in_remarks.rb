class RenamingBackColumnInRemarks < ActiveRecord::Migration
  def up
  	rename_column :remarks, :type, :remark_type  
  end

  def down
  	rename_column :remarks, :remark_type, :type  
  end
end
