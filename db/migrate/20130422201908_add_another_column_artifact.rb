class AddAnotherColumnArtifact < ActiveRecord::Migration
  def change
  	add_column :artifacts, :content_type, :string
  end
end
