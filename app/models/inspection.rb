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
  attr_accessible :comment, :name
  has_many :artifacts, :dependent => :destroy
  has_many :chat_messages, :dependent => :destroy
  has_many :remarks, :dependent => :destroy
  belongs_to :campaign
  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations
  has_many :deadlines, :dependent => :destroy

  VALID_STATUS_REGEX = /\A(active)|(archived)|(preparation)|(inspection)|(rework)|(finished)|(closed)\z/

  before_validation { |i| i.active! if i.status.nil? }
  #after_create "puts 'inspection created'"
  validates :name, presence: true
  # status can be only lowecased
  validates :status, presence: true,
            format: {with: VALID_STATUS_REGEX}

  after_create { |i| i.default_deadline! if !i.valid_deadlines?  }

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

  def deadlines_to_hash
    Hash[self.deadlines.map{|d| [d.name, d.endDate]}]
  end
  def valid_deadlines?
    if ((self.class.status_list | self.deadlines.map(&:name)) - (self.class.status_list & self.deadlines.map(&:name))).empty?
      #!self.deadlines.each_cons(2).map {|a, b| a.endDate <= b.startDate }.include?(false)
      !self.deadlines.each_cons(2).map {|a, b| a.endDate <= b.endDate }.include?(false)
    else
      false
    end
  end
  def valid_deadlines?(name, endDate)
        #!self.deadlines.each_cons(2).map {|a, b| a.endDate <= b.startDate }.include?(false)
      false if !self.class.status_list.include?(name) || !endDate.class.to_s == "Date"
      deadlines = self.deadlines_to_hash
      deadlines[name] = endDate
      !deadlines.values.each_cons(2).map {|a, b| a <= b }.include?(false)
  end
  def update_deadline(name, endDate)
      if self.valid_deadlines?(name, endDate) && self.class.status_list.include?(name)
        self.deadlines.find_by_name(name).update_attributes(endDate: endDate)
        true
      else
        false
      end
  end
  def default_deadline!
    self.deadlines.delete_all
    self.class.status_list.each_with_index do |status, index|
      #self.deadlines.create(name: status, endDate: (3*(index+1)).days.from_now, startDate: (3*(index)).days.from_now)
      self.deadlines.create(name: status, endDate: (3*(index+1)).days.from_now.to_date, startDate: Date.today)
    end
  end
  def self.status_list
    ['preparation','inspection','rework','finished']
  end
  def self.admin_status_list
    self.status_list
    #return ['active','archived','preparation','inspection','rework','finished','closed']
  end




end
