class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :chat_messages, [:user_id, :created_at]
    add_index :users, :id
  end
end
