class CreateRemarks < ActiveRecord::Migration
  def change
    create_table :remarks do |t|
      t.string :location
      t.string :string
      t.string :content
      t.string :string
      t.string :user_id
      t.string :integer
      t.string :inspection_id
      t.string :integer
      t.string :remark_type
      t.string :string

      t.timestamps
    end
  end
end
