class AddColumnsArtifact < ActiveRecord::Migration
  def change
  	add_column :artifacts, :filename, :string
  end
end
