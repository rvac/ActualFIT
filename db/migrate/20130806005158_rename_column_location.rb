class RenameColumnLocation < ActiveRecord::Migration
  def up
    rename_column :locations, :inspection_id, :remark_id
    remove_column :remarks, :location
  end

  def down
    rename_column :locations, :remark_id, :inspection_id
    add_column :remarks, :location, :string
  end
end
