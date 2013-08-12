# == Schema Information
#
# Table name: remarks
#
#  id             :integer          not null, primary key
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
#

class Remark < ActiveRecord::Base
  resourcify
  attr_accessible :content, :location_type, :remark_type, :description, :element_type, :element_number, :element_name, :line_number, :diagram, :path
  belongs_to :user
  belongs_to :inspection
  belongs_to :artifact

  VALID_LOCATION_TYPE_REGEX = /\A((code)|(document)|(model))\z/
  validates :location_type, presence: true, format: {with: VALID_LOCATION_TYPE_REGEX}
  validate :location_valid?
  validates :inspection_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
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
        elsif !row["email"].nil?
          user = User.find_by_email(row["email"]) || User.new#try something else. Write factory for user
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
    return ['minor', 'major', 'comment']
  end

  def self.document_element_type
    ['page', 'section','table','figure','footnote','line']
  end
  def self.location_type_list
    ['code', 'document','model']
  end
  def location_valid?
    case self.location_type
      when 'code'
        return true if !self.line_number.nil?
        errors.add(:base, "Line number should not be empty for type code")
        return false
      when 'document'
        return true if !self.element_type.nil? && !self.element_name.nil?
        errors.add(:base, "Element type and element name should not be empty for type document")
        return false
      when 'model'
        return true if !self.path.nil? || (!self.diagram.nil?) || (!self.element_type.nil? && !self.element_name.nil?)
        errors.add(:base, "Either path, diagram or element type and name should not be empty for type model")
        return false
      else
        errors.add(:base, "Wrong location type")
        return false
    end
        #if smth go wrong
    return false
  end

  #overwriting to_s method to our needs
  def location_to_s
    case self.location_type
      when 'code'
        return "line #{self.line_number}"
      when 'document'
        if self.element_number.nil?
          return "#{self.element_type} #{self.element_name}"
        else
          return "#{self.element_type} #{self.element_name} #{self.element_number}"
        end
      when 'model'
        if !self.diagram.nil? && !self.diagram.empty?
             return "#{self.diagram}"
        elsif self.path.nil? || self.path.empty?
          if self.element_number.nil? || self.element_number.empty?
            return "#{self.element_type} #{self.element_name}"
          else
            return "#{self.element_type} #{self.element_name} #{self.element_number}"
          end
        else
          return "#{self.path}"
        end
      else
        return ''
    end
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
