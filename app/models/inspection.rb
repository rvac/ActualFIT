# == Schema Information
#
# Table name: inspections
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  comment     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campaign_id :integer
#  status      :string(255)
#

class Inspection < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :name , :status
  has_many :artifacts, :dependent => :destroy
  has_many :chat_messages, :dependent => :destroy
  has_many :remarks, :dependent => :destroy
  belongs_to :campaign
  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations
  has_many :deadlines, :dependent => :destroy
  after_create :active!
  validates :name, presence: true
  VALID_STATUS_REGEX = /\A(active)|(archived)\z/i

  validates :status, presence: true,
            format: {with: VALID_STATUS_REGEX}


  def active?
    self.status == 'active'
  end

  def active!
    self.status = 'active'
  end
  def archived?
    self.status == 'archived'
    end


end
