# == Schema Information
#
# Table name: deadlines
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  startDate  :datetime
#  endDate    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Deadline < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :endDate, :name, :startDate
  belongs_to :inspection

end
