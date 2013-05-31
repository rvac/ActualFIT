# == Schema Information
#
# Table name: inspections
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  comment            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  inspection_team_id :integer
#  campaign_id        :integer
#  status             :string(255)
#

class Inspection < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :name , :status
  has_many :artifacts
  has_many :chat_messages
  has_many :remarks
  belongs_to :campaign
  has_many :participations
  has_many :users, :through => :participations

  validates :name, presence: true
  VALID_STATUS_REGEX = /\A(active)|(archived)\z/i

  validates :status, presence: true,
            format: {with: VALID_STATUS_REGEX}

  def active?
    self.status == 'active'
  end

  def archived?
    self.status == 'archived'
    end


end
