# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string(255)
#

require 'fileutils'

class Campaign < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :name, :assignments
  has_many :inspections, :dependent => :destroy

  validates :name, presence: true
  VALID_STATUS_REGEX = /\A(open)|(closed)\z/

  validates :status, presence: true,
            format: {with: VALID_STATUS_REGEX}
  before_validation { |c| c.status = 'open' }
  after_create :create_inspections
  after_create 'FileUtils.rm @new_file_link, force: true if @new_file_link'

  def assignments=(file)
    if !file.nil?
      @new_file_link = "#{file.path}#{File.extname(file.original_filename)}"
      FileUtils.ln file.path, @new_file_link, force: true
    end
  end
  private
    def open_spreadsheet()
      #make something smart afterwards
      case File.extname(@new_file_link)
        when ".csv" then Roo::Csv.new(@new_file_link)
        when ".xls" then Roo::Excel.new(@new_file_link)
        when ".xlsx" then Roo::Excelx.new(@new_file_link)
        else raise "Unknown file type: "
      end
    end

    def create_inspections
      if !@new_file_link.nil?
        spreadsheet = open_spreadsheet()
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          #user creation
          if !row["S-number"].nil?
            user = User.s_user_find_or_create row["S-number"]
            if user.new_record?
              user = User.new
              user.assign_attributes ({name: "#{row["First name"]} #{row["Last name"]}", email: "#{row["S-number"]}@student.dtu.dk",
                                       password: row["S-number"], password_confirmation: row["S-number"]})
              errors.add(:base, "User from row #{i} can not be created") if !user.save # may be make user.save! and rescue from exception
            end
          else
            user = User.new #add regexp for searching email field, name field, etc that search user with that email, etc
                            #user.name = "#{row["First name"]}#{row["Last name"]}"
          end
          #inspection creation
          if !row["Group"].nil?
            inspection = self.inspections.find_by_name(row["Group"]) || self.inspections.build(name: row["Group"])
            inspection.active!
            #if user for that inspection exist, than update his rights
            if !user.new_record? && inspection.valid?
              inspection.remove_user(user) if inspection.users.include?(user)
              case row["Role"]
                when /\A((i)|(inspector))\z/i then
                  if inspection.team_valid? "inspector"
                    inspection.add_user user, "inspector"

                    #user.grant :inspector, inspection  #apply regexp later here
                  else
                    puts "ERROR #{user.name} #{inspection.id} inspector"
                    puts inspection
                    errors.add(:base, "Wrong role #{row["Role"]} for #{user.name} in row #{i}")
                  end
                when /\A((m)|(moderator))\z/i then
                  if inspection.team_valid? "moderator"
                    inspection.add_user user,  "moderator"

                    #user.grant :moderator, inspection  #apply regexp later here
                  else
                    puts "ERROR #{user.name} #{inspection.id} moderator"
                    puts inspection
                    errors.add(:base, "Possible duplicate role #{row["Role"]} in inspection #{inspection.name}, row #{i}")
                  end
                when /\A((a)|(author))\z/i then
                  if inspection.team_valid? "author"
                    inspection.add_user user,  "author"
                    #user.grant :author, inspection  #apply regexp later here
                  else
                    puts "ERROR! #{user.name} #{inspection.id} author"
                    puts inspection
                    errors.add(:base, "Possible duplicate role #{row["Role"]} in inspection #{inspection.name}, row #{i}")
                  end
                else
                  errors.add(:base, "Wrong role #{row["Role"]} for #{user.name} in row #{i}")
              end
            end
          else
            errors.add(:base, "Group column is empty in row #{i}")
          end
        end
      end
    end
end
