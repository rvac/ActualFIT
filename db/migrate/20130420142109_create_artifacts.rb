class CreateArtifacts < ActiveRecord::Migration
  def change
    create_table :artifacts do |t|
      t.string :name
      t.string :comment
      t.integer :inspection_id
      t.binary :file, limit: 50.megabyte

      t.timestamps
    end
    add_index :artifacts, :inspection_id
  end
end
