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
  rolify

	attr_accessible :email, :name, :password, :password_confirmation , :skype, :phone, :address, :additional_info
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

  #def name
  #  "#{} #{}"
  #end
  #
  private
		def create_remember_token
		  #create the token here
		  self.remember_token = SecureRandom.urlsafe_base64
		end


end
