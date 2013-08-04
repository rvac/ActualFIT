# == Schema Information
#
# Table name: remarks
#
#  id            :integer          not null, primary key
#  location      :string(255)
#  content       :string(255)
#  user_id       :integer
#  inspection_id :integer
#  remark_type   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  artifact_id   :integer
#

class Remark < ActiveRecord::Base
  resourcify
  attr_accessible :content, :location,
  			 :remark_type
  belongs_to :user
  belongs_to :inspection
  belongs_to :artifact

  VALID_LOCATION_REGEX = /\A((line)|(diagram)|(picture)|(figure)|(inspection))\s\d*\z/i

  validates :inspection_id, presence: true
  # validates :remark_type, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
  validates :location, presence: true,
            format: { with: VALID_LOCATION_REGEX }
  validates :remark_type, presence: true

  def self.parse_excel(file, inspection)
    if !file.nil?
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      #deal with headers here
      (2..spreadsheet.last_row).each do |i|

        row = Hash[[header, spreadsheet.row(i)].transpose]
        #user creation
        if !row["s-number"].nil?
          user = self.s_user_find row["s-number"]
        else
          #try something else. Write factory for user
        end

        if !user.new_record?
          remark = inspection.remarks.build( content: row["remark"], location: row["location"], remark_type: row["type"] )
          remark.user_id = user.id
          # look for artifact with row["artifact"] name, if found - assign artifact_id, otherwise nill
          # do something smart with map inspection.artifacts (e.g. get names into hash(name, id) array
          # and search in array) and than assign id or nil
          remark.save
          # write check up if saved? many checkups
        else
          #write to error message this line number, no user
        end
      end
    end
  end
  def self.possible_remark_type
    return ['minor', 'medium', 'major']
  end
  private
    def self.open_spreadsheet(file)
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

    def self.s_user_find(s_number)
      user = User.find_by_email("#{s_number}@student.dtu.dk") || User.new

    end
end
