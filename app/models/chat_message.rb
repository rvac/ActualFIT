# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatMessage < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user
  validates :user_id, presence: true
end
