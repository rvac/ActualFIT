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

  VALID_STATUS_REGEX = /\A(setup)|(upload)|(prepare)|(summary)|(inspection)|(rework)|(finished)|(archived)\z/

  before_validation { |i| i.active! if i.status.nil? }
  #after_create "puts 'inspection created'"
  validates :name, presence: true
  # status can be only lowecased
  validates :status, presence: true,
            format: {with: VALID_STATUS_REGEX}

  after_create { |i| i.default_deadline! if !i.deadlines_valid?  }

  def active?
    !((self.status == 'archived'))
  end

  def active!
    self.status = 'setup'
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

  def dueDates_to_hash
    Hash[self.deadlines.map{|d| [d.name, d.dueDate]}]
    end
  def closeDates_to_hash
    Hash[self.deadlines.map{|d| [d.name, d.closeDate]}]
  end
  def deadlines_valid?
    if ((self.class.status_list | self.deadlines.map(&:name)) - (self.class.status_list & self.deadlines.map(&:name))).empty?
      #!self.deadlines.each_cons(2).map {|a, b| a.dueDate <= b.startDate }.include?(false)
      !self.deadlines.each_cons(2).map {|a, b| a.dueDate <= b.dueDate }.include?(false)
    else
      false
    end
  end
  def deadline_valid?(name, endDate)
        #!self.deadlines.each_cons(2).map {|a, b| a.dueDate <= b.startDate }.include?(false)
      false if !self.class.status_list.include?(name) || !endDate.class.to_s == "Date"
      deadlines = self.dueDates_to_hash
      deadlines[name] = endDate
      !deadlines.values.each_cons(2).map {|a, b| a <= b }.include?(false)
  end
  def update_deadline(name, endDate)
      if self.deadline_valid?(name, endDate) && self.class.status_list.include?(name)
        self.deadlines.find_by_name(name).update_attributes(dueDate: endDate)
        true
      else
        false
      end
  end
  def close_deadline(old_status)
      #for range between old and new status change closeDate of a corresponding deadline
  end
  def default_deadline!
    self.deadlines.delete_all
    self.class.status_list.each_with_index do |status, index|
      self.deadlines.create(name: status, dueDate: (2*(index+1)).days.from_now.to_date)
    end
  end

  def status_of_status(status)

    if self.class.status_list.index(status) < self.class.status_list.index(self.status)
      "done"
    elsif status == self.status
      "active"
    else
      "future"
    end
  end
  def team_complete?
    (self.class.minimal_team - self.roles.map(&:name)).empty?
  end

  def team_valid?(new_role = nil)
    if !new_role.nil? && new_role.class == String
       case new_role
         when 'author', 'moderator'
           if  self.roles.map(&:name).count(new_role) == 1
              return false
           else
              return true
           end
         else
           return true
       end
    else
       team = self.roles.map(&:name)
       return false if team.count("author") != 1
       return false if team.count("moderator") != 1
       return false if team.count("inspector") < 1
       true
    end
  end



  def self.status_list
    ['setup', 'upload', 'prepare', 'summary', 'inspection', 'rework', 'finished']
  end
  def self.admin_status_list
    self.status_list
    #return ['active','archived','preparation','inspection','rework','finished','closed']
  end

  def self.minimal_team
    ["author", "moderator", "inspector"]
  end


end
