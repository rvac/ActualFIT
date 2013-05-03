class AddedUserIdToArtifact < ActiveRecord::Migration
  def up
    add_column :artifacts, :user_id, :integer
  end

  def down
    remove_column :artifacts, :user_id
  end
end
