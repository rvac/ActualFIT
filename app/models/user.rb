# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#  skype           :string(255)
#  phone           :string(255)
#  address         :string(255)
#  additional_info :string(255)
#  profile_picture :binary(256000)
#  content_type    :string(255)
#

class User < ActiveRecord::Base
  rolify

	attr_accessible :email, :name, :password, :password_confirmation , :skype, :phone, :address, :additional_info, :datafile
	has_secure_password
	has_many :chat_messages, :dependent => :destroy
  has_many :participations, :dependent => :destroy
  has_many :inspections, :through => :participations
	has_many :remarks, :dependent => :destroy
  has_many :artifacts, :dependent => :destroy

	before_save { email.downcase! }
	before_save :create_remember_token

	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true,
						format: {with: VALID_EMAIL_REGEX},
						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true
  after_create :default_profile_picture

  def datafile=(incoming_file)
    if ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg'].include?(incoming_file.content_type)
      self.content_type = incoming_file.content_type
      self.profile_picture = incoming_file.read
      incoming_file.rewind
    else
      errors.add(:profile_picture, 'should be a png, jpg or gif image')
    end
  end

  def self.s_user_find_or_create(s_number)
    user = User.find_by_email("#{s_number}@student.dtu.dk") || User.new
  end
  #def initialize(attributes = nil, options = {})
  #  self.initialize(attributes, options)
  #end
  private
    def default_profile_picture
      if self.profile_picture.nil?
        picture = File.open(Rails.public_path + "/templates/blank-profile-photo.jpg", "rb")
        self.profile_picture = picture.read
        self.content_type = "image/jpg"# code here
        picture.close
        self.save
      end
    end

    def sanitize_filename(filename)
      just_filename = File.basename(filename)
      just_filename.gsub(/[^\w\.\-]/, '_')
    end

		def create_remember_token
		  #create the token here
		  self.remember_token = SecureRandom.urlsafe_base64
		end


end
