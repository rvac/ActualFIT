class Deadline < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :endDate, :name, :startDate
  belongs_to :inspection

end
