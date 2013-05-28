# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Campaign < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :name
  has_many :inspections, :dependent => :destroy

  validate :name, presence: true
end
