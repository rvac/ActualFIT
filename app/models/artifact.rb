# == Schema Information
#
# Table name: artifacts
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  comment       :string(255)
#  inspection_id :integer
#  file          :binary(52428800)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  filename      :string(255)
#  content_type  :string(255)
#  user_id       :integer
#

class Artifact < ActiveRecord::Base
  resourcify
  attr_accessible :comment, :name, :datafile
  belongs_to :inspection
  belongs_to :user
  has_many :remarks, :dependent => :destroy

  validates :name, presence: true
  validates :file, presence: true
  validates :filename, presence: true
  validates :inspection_id, presence: true
  validates :user_id, presence: true
  validates :content_type, presence: true

  before_validation { |artifact| if artifact.name.empty? then artifact.name = artifact.filename end }

  def datafile=(incoming_file)
    self.filename = sanitize_filename incoming_file.original_filename
    self.content_type = incoming_file.content_type
    self.file = incoming_file.read
    incoming_file.rewind
  end
  #def initialize(attributes = nil, options = {})
  #  self.initialize(attributes, options)
  #end
  private
  def sanitize_filename(filename)
    just_filename = File.basename(filename)
    just_filename.gsub(/[^\w\.\-]/, '_')
  end
end
