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
  #has_many :deadlines, :dependent => :destroy
  before_create :active!
  after_create "puts 'inspection created'"
  validates :name, presence: true
  # status can be only lowecased
  VALID_STATUS_REGEX = /\A(active)|(archived)|(preparation)|(inspection)|(rework)|(finished)|(closed)\z/

  validates :status, presence: true,
            format: {with: VALID_STATUS_REGEX}


  def active?
    !((self.status == 'archived') || (self.status == 'closed'))
  end

  def active!
    self.status = 'active'
  end
  def archived?
    self.status == 'archived'
  end
  def fullname
    campaign = Campaign.find(self.campaign_id) if !self.campaign_id.nil?
    if !campaign.nil?
      "#{campaign.name} #{self.name}"
    else
      self.name
    end
  end
  def self.status_list
    return ['preparation','inspection','rework','finished']
  end
  def self.admin_status_list
    return ['active','archived','preparation','inspection','rework','finished','closed']
  end


end
