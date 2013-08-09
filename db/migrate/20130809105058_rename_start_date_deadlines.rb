class RenameStartDateDeadlines < ActiveRecord::Migration
  def up
    rename_column :deadlines, :endDate, :dueDate
    rename_column :deadlines, :startDate, :closeDate
  end

  def down
    rename_column :deadlines, :dueDate, :endDate
    rename_column :deadlines, :closeDate, :startDate
  end
end
