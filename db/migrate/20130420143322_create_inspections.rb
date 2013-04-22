class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.string :name
      t.string :comment

      t.timestamps
    end
    add_index :inspections, :name
  end
end
