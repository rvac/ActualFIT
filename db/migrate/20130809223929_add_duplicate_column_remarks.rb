class AddDuplicateColumnRemarks < ActiveRecord::Migration
  def up
    add_column :remarks, :duplicate_of, :integer
    add_column :remarks, :has_duplicates, :boolean
  end

  def down
    remove_column :remarks, :duplicate_of
    remove_column :remarks, :has_duplicates
  end
end
