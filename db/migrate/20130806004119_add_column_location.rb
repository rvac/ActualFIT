class AddColumnLocation < ActiveRecord::Migration
  def up
    add_column :locations, :inspection_id, :integer
    add_column :locations, :description, :string
    add_column :locations, :element_type, :string
    add_column :locations, :element_number, :string
    add_column :locations, :element_name, :string
    add_column :locations, :diagram, :string
    add_column :locations, :path, :string
    add_column :locations, :line_number, :integer

  end

  def down
    remove_column :locations, :description
    remove_column :locations, :element_type
    remove_column :locations, :element_number
    remove_column :locations, :element_name
    remove_column :locations, :diagram
    remove_column :locations, :path
    remove_column :locations, :line_number
    remove_column :locations, :inspection_id
  end
end
