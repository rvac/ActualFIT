class MoveLocationToRemarkTable < ActiveRecord::Migration
  def up
    drop_table :locations
    add_column :remarks, :location_type, :string
    add_column :remarks, :description, :string
    add_column :remarks, :element_type, :string
    add_column :remarks, :element_number, :string
    add_column :remarks, :element_name, :string
    add_column :remarks, :diagram, :string
    add_column :remarks, :path, :string
    add_column :remarks, :line_number, :integer
  end

  def down
    remove_column :remarks, :location_type
    remove_column :remarks, :description
    remove_column :remarks, :element_type
    remove_column :remarks, :element_number
    remove_column :remarks, :element_name
    remove_column :remarks, :diagram
    remove_column :remarks, :path
    remove_column :remarks, :line_number
    raise ActiveRecord::IrreversibleMigration
  end
end
