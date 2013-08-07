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

require 'spec_helper'

describe User do
  it "is valid with a name, email and password" do
    expect(create(:user)).to be_valid
  end
  #it "creates valid admin" do
  #  expect(create(:admin)).to be_valid
  #end
  #it "creates valid author" do
  #  expect(create(:author)).to be_valid
  #end
  #it "creates valid supervisor" do
  #  expect(create(:supervisor)).to be_valid
  #end
  #it "creates valid moderator" do
  #  expect(create(:moderator)).to be_valid
  #end
  #it "creates valid inspector" do
  #  expect(create(:inspector)).to be_valid
  #end
  describe "is invalid when"  do
    let(:user) {build(:user)}

    it "has no name" do
      expect(build(:user, name: nil)).to have(1).errors_on(:name)
    end

    context "email" do
      it "is absent" do
        expect(build(:user, email: nil)).to have(2).errors_on(:email)
      end
      it "is wrong" do
        expect(build(:user, email: "iswery@wrong")).to have(1).errors_on(:email)
      end
      it "is duplicate" do
        duplicate_user = build(:user, email: user[:email])
        user.save
        expect(duplicate_user).to_not be_valid
        expect(duplicate_user).to have(1).errors_on(:email)

        # check uniqueness and blankness errors
      end
    end

    context "password" do
      #@user[:password] = nil
      it "is empty" do
        expect(build(:user, password: nil)).to have(3).errors_on(:password)
      end
      it "confirmation is empty" do
        expect(build(:user, password_confirmation: nil)).to have(1).errors_on(:password_confirmation)
      end
      it "confirmation does not match" do
        expect(build(:user, password_confirmation: "wrongconfirmation")).to have(1).errors_on(:password)
      end
      #add testing that pwd & confirmation should match, password length and password blank
    end
  end
end
