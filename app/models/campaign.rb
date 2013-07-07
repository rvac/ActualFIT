# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'fileutils'

class Campaign < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :name, :assignments
  has_many :inspections, :dependent => :destroy

  validate :name, presence: true
  after_create 'FileUtils.rm @new_file_link, force: true if @new_file_link'

  def assignments=(file)
    if !file.nil?
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        #user creation
        if !row["S-number"].nil?
          user = s_user_find_or_create row["S-number"]
          if user.new_record?
            user = User.new
            user.assign_attributes ({name: "#{row["First name"]} #{row["Last name"]}", email: "#{row["S-number"]}@student.dtu.dk",
                                      password: row["S-number"], password_confirmation: row["S-number"]})
            user.save          # may be make user.save! and rescue from exception
          end
        else
          user = User.new #add regexp for searching email field, name field, etc that search user with that email, etc
          #user.name = "#{row["First name"]}#{row["Last name"]}"

        end

        #inspection creation
        inspection = self.inspections.find_by_name(row["Group"]) || self.inspections.build(name: row["Group"], status: "active")
        #
        #user.inspections << inspection
        #inspection.users << user
        #create participation
        #give permissions
        case row["Role"]
          when "I" then
            user.grant :inspector, inspection  #apply regexp later here
            Participation.create user: user, inspection: inspection, role: "inspector"
            puts "#{user.name} #{inspection.id} inspector"
          when "M" then
            user.grant :moderator, inspection  #apply regexp later here
            Participation.create user: user, inspection: inspection, role: "moderator"
            puts "#{user.name} #{inspection.id} moderator"
          when "A" then
            user.grant :author, inspection  #apply regexp later here
            Participation.create user: user, inspection: inspection, role: "author"
            puts "#{user.name} #{inspection.id} author"
          else  puts "oops expect some kind of warning here"
        end

      end
    end
  end

  private
    def open_spreadsheet(file)
      #make something smart afterwards
      @new_file_link = "#{file.path}#{File.extname(file.original_filename)}"
      FileUtils.ln file.path, @new_file_link, force: true
      case File.extname(file.original_filename)
        when ".csv" then Roo::Csv.new(@new_file_link)
        when ".xls" then Roo::Excel.new(@new_file_link)
        when ".xlsx" then Roo::Excelx.new(@new_file_link)
        else raise "Unknown file type: #{file.original_filename}"
      end

    end

    def s_user_find_or_create(s_number)
      user = User.find_by_email("#{s_number}@student.dtu.dk") || User.new

    end


end
