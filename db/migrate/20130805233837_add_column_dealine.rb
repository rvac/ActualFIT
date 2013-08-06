class AddColumnDealine < ActiveRecord::Migration
  def up
    add_column :deadlines, :inspection_id, :integer
  end

  def down
    remove_column :deadlines, :inspection_id
  end
end
