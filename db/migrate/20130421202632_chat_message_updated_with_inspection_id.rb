class ChatMessageUpdatedWithInspectionId < ActiveRecord::Migration
  def change
  	add_column :chat_messages, :inspection_id, :integer
  end
end
