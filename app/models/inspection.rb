# == Schema Information
#
# Table name: inspections
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Inspection < ActiveRecord::Base
  attr_accessible :comment, :name
  has_many :artifacts
  has_many :chat_messages
  
  validates :name, presence: true
end
