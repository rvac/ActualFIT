# == Schema Information
#
# Table name: chat_messages
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  inspection_id :integer
#

class ChatMessage < ActiveRecord::Base
  resourcify
  attr_accessible :content
  # add validation of the user id
  belongs_to :user
  belongs_to :inspection


  validates :inspection_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 4080 }
  default_scope order: 'chat_messages.created_at ASC'
end
