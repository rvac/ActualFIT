# == Schema Information
#
# Table name: inspection_teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InspectionTeam < ActiveRecord::Base
  attr_accessible :name, :user_id
  has_many :inspections
  belongs_to :user

  validates :name, presence: true
  
end
