class AddTypeToLocation < ActiveRecord::Migration
  def up
    add_column :locations, :type, :string
  end

  def down
    remove_column :locations, :type
  end
end
