class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.string :name
      t.string :comment
      t.datetime :startDate
      t.datetime :endDate

      t.timestamps
    end
  end
end
