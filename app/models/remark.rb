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
  after_validation :cleanup_location
  def self.parse_excel(file, inspection, current_user = nil)
    if !file.nil? && inspection.class == Inspection && !current_user.nil?
      spreadsheet = open_spreadsheet(file)
      #deal with headers here
      header = spreadsheet.row(1)
      #put into hash all artifact names, so save a little if have a lot of remarks
      duplicates = 0
      new_remarks = 0
      artifact = Hash[inspection.artifacts.map{|a| [a.name, a.id]}]
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        #user creation
        if current_user.has_role?(:moderator, inspection) && !row["s-number"].nil?
          user = self.s_user_find(row["s-number"]) || current_user
        elsif
          user = current_user
        end
        remark = Remark.new(content: row["content"], location_type: row["location_type"], remark_type: row["remark_level"], element_type: row["element_type"], element_number: row["element_number"], element_name: row["element_name"], line_number: row["line_number"], diagram: row["diagram"], path: row["path"] )
        remark.artifact_id = artifact[row["object"]]
        if inspection.remarks.map {|r| remark.duplicate_of?(r)}.include?(true)
          duplicates += 1
        else
          remark.user_id = user.id
          remark.inspection_id = inspection.id
          if remark.save
             new_remarks += 1
          else
            inspection.errors.add(:base, "Remark on line #{i} is corrupted")#bad situation, remark unsaved
          end
          #write to error message this line number, no user
        end
      end
      inspection.errors.add(:base, "#{duplicates} duplicates not imported") unless duplicates == 0
      inspection.errors.add(:base, "#{new_remarks} remarks created") unless duplicates == 0
      return true
    end
    return false
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

  def same_location?(remark)
    return false unless remark.class == Remark
    if ( self.artifact_id == remark.artifact_id ) && ( self.location_type == remark.location_type )
      case self.location_type
        when 'code'
          return true if self.line_number == remark.line_number
          return false
        when 'document'
          return true if (self.element_type == remark.element_type) && (self.element_number == remark.element_number) && (self.element_name == remark.element_name)
          return false
        when 'model'
          return true if (self.element_type == remark.element_type) && (self.diagram == remark.diagram) && (self.element_name == remark.element_name) && (self.path == remark.path)
          return false
        else
          return false
      end
    else
      return false
    end
  end

  def duplicate_of?(remark)
    return false unless remark.class == Remark
    if self.same_location?(remark) && (self.content == remark.content)
      remark.has_duplicates = true
      self.duplicate_of = remark.id
      # do we need this check up?
      if remark.duplicate_of == self.id
        self.has_duplicates = nil
        remark.duplicate_of = nil
      end
      return true
    else
      return false
    end
  end
  def location_valid?
    case self.location_type
      when 'code'
        return true if (!self.line_number.nil?)
        errors.add(:base, "Line number should not be empty for type code")
        return false
      when 'document'
        return true if (!self.element_type.nil? && !self.element_type.empty? )&& (!self.element_name.nil? && !self.element_name.empty?)
        errors.add(:base, "Element type and element name should not be empty for type document")
        return false
      when 'model'
        return true if (!self.path.nil? && !self.path.empty? )|| (!self.diagram.nil? && !self.diagram.empty?) || ((!self.element_type.nil? && !self.element_type.empty? ) && (!self.element_name.nil? && !self.element_name.empty?))
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
    def cleanup_location
      case self.location_type
        when 'code'
          self.element_type = nil
          self.element_name = nil
          self.element_number = nil
          self.path = nil
          self.diagram = nil
        when 'document'
          self.line_number = nil
          self.path = nil
          self.diagram = nil
        when 'model'
          self.line_number = nil
          self.element_number = nil
        else
          return
      end
    end
    def self.s_user_find(s_number)
      user = User.find_by_email("#{s_number}@student.dtu.dk")
    end
end
