# == Schema Information
#
# Table name: deadlines
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  comment       :string(255)
#  startDate     :date
#  endDate       :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  inspection_id :integer
#

class Deadline < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :dueDate, :name
  belongs_to :inspection

  VALID_NAME_REGEX = /\A(setup)|(upload)|(prepare)|(summary)|(inspection)|(rework)|(finished)|(closed)\z/

  validates :name, presence: true, format: {with: VALID_NAME_REGEX}
  validates :dueDate, presence: true
  #validate :possible_deadline?
  #
  #def possible_deadline?
  #  if !(self.startDate.nil? || self.endDate.nil?)
  #    if self.endDate < self.startDate
  #      errors.add(:base, 'The start date must precede the end date')
  #    end
  #  end
  #end
  def missedDeadline?
    if self.closeDate.nil?
      self.dueDate.to_date < Date.today
    else
      self.dueDate.to_date < self.closeDate.to_date
    end
  end
end
