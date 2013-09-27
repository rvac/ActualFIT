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

  VALID_STATUS_REGEX = /\A(setup)|(upload)|(prepare)|(inspection)|(rework)|(finished)|(archived)\z/

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

  def deadlines_to_hash
    Hash[self.deadlines.map{|d| [d.name, [d.dueDate, d.missed_deadline?]]}]
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
      #false if !self.class.status_list.include?(name) || !endDate.class.to_s == "Date"
      #deadlines =  Hash[self.deadlines_to_hash.map {|k,v| [k, v.first]} ]
      #deadlines[name] = endDate
      #!deadlines.values.each_cons(2).map {|a, b| a <= b }.include?(false)
      true
  end
  def update_deadline(name, endDate, comment = nil)
      if self.deadline_valid?(name, endDate) && self.class.status_list.include?(name)
        self.deadlines.find_by_name(name).update_attributes(dueDate: endDate, comment: comment)
        true
      else
        self.errors.add(:base, "#{endDate} is incorrect deadline date for #{name.titleize} stage")
        false
      end
  end
  def close_deadline(old_status)
      self.deadlines.select {|d| self.status_of_status(d.name) == 'done' && d.closeDate.nil?}.each do |d|
        d.closeDate = Date.today
        d.save
        #for range between old and new status change closeDate of a corresponding deadline
      end
      if self.status == 'finished'
        d = self.deadlines.last
        d.closeDate = Date.today
        d.save
      end
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

  def change_status(status)
    if  ['prepare', 'inspection', 'rework', 'finished'].include?(status)
      if self.artifacts.count < 1
        errors.add(:base, "You should upload at least one artifact before going to #{status.titleize} stage")
        return false
      end
    elsif ['rework', 'finished'].include?(status)
      if self.remarks.count < 1
        errors.add(:base, "You add some remarks before going to #{status.titleize} stage")
        return false
      end
    end
    self.status = status
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

  def add_user(user, role)
    if (Role.possible_roles.include? role) && (user.class == User)
      Participation.create user: user, inspection: self, role: role
      user.grant role, self

      puts "#{user.name} #{self.id} #{role}"
      puts self
      true
    end
    false
  end

  def remove_user(user)
    if user.class == User && self.users.include?(user)
      Role.possible_roles do |r|
        user.revoke r, @inspection
      end
      Participation.find_by_user_id_and_inspection_id(user.id, self.id).destroy
      true
    else
      false
    end
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      col_nam = Remark.column_names
      #object	location_type	element_type	element_name	element_number	line_number	path	diagram	content	remark_level	s-number
      #  content        :string(255)
      #  user_id        :integer
      #  inspection_id  :integer
      #  remark_type    :string(255)
      #  created_at     :datetime
      #  updated_at     :datetime
      #  artifact_id    :integer
      #  duplicate_of   :integer
      #  has_duplicates :boolean
      #  location_type  :string(255)
      #  description    :string(255)
      #  element_type   :string(255)
      #  element_number :string(255)
      #  element_name   :string(255)
      #  diagram        :string(255)
      #  path           :string(255)
      #  line_number    :integer
      header = ['object', 'location_type', 'element_type', 'element_name', 'element_number', 'line_number', 'path', 'diagram', 'content', 'remark_level', 'email']
      col_names = [ 'location_type', 'element_type', 'element_name', 'element_number', 'line_number', 'path', 'diagram', 'content', 'remark_type']
      csv << header
      self.remarks.each do |r|
        row = r.attributes.values_at(*col_names)
        r.artifact_id.nil? ? row.prepend("") : row.prepend(Artifact.find(r.artifact_id).name)
        row.append(User.find(r.user_id).email)
        csv << row
      end
    end
  end
  def self.status_list
    ['setup', 'upload', 'prepare', 'inspection', 'rework', 'finished']
  end
  def self.admin_status_list
    self.status_list
    #return ['active','archived','preparation','inspection','rework','finished','closed']
  end

  def self.minimal_team
    ["author", "moderator", "inspector"]
  end


end
