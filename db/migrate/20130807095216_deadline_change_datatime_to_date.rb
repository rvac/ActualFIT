class DeadlineChangeDatatimeToDate < ActiveRecord::Migration
  def up
    change_column :deadlines, :endDate, :date
    change_column :deadlines, :startDate, :date
  end

  def down
    change_column :deadlines, :endDate, :datetime
    change_column :deadlines, :startDate, :datetime
  end
end
