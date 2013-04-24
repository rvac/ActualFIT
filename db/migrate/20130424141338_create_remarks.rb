class CreateRemarks < ActiveRecord::Migration
  def change
    create_table :remarks do |t|
      t.string :location
      t.string :content
      t.integer :user_id
      t.integer :inspection_id
      t.string :remark_type


      t.timestamps
    end
  end
end
