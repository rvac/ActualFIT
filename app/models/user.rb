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
#

class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	has_secure_password
	has_many :chat_messages
	has_many :inspection_teams
	has_many :remarks
	
	before_save { email.downcase! }
	before_save :create_remember_token
	before_save :default_values
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_ROLE_REGEX = /\A(user\s?)?(admin\s?)?(moderator\s?)?(supervisor\s?)?(author\s?)?(scribe\s?)?\z/
	validates :email, presence: true,
						format: {with: VALID_EMAIL_REGEX},
						uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }
	validates :password_confirmation, presence: true
	validates :role, presence: true, format: {with: VALID_ROLE_REGEX}
	private 
		def create_remember_token
		  #create the token here
		  self.remember_token = SecureRandom.urlsafe_base64
		end

		def default_values
			self.role ||= 'user'
		end
end
