# == Schema Information
#
# Table name: remarks
#
#  id            :integer          not null, primary key
#  location      :string(255)
#  content       :string(255)
#  user_id       :integer
#  inspection_id :integer
#  remark_type   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  artifact_id   :integer
#

class Remark < ActiveRecord::Base
  attr_accessible :content, :inspection_id, :location,
  			 :remark_type, :user_id, :artifact_id
  belongs_to :user
  belongs_to :inspection
  belongs_to :artifact
  
  validates :inspection_id, presence: true
  # validates :remark_type, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
end
