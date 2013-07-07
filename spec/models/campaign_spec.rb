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

require 'spec_helper'

describe Campaign do
  describe "is valid when" do
    it "has valid factory" do
      expect(build(:campaign)).to be_valid
    end
  end

  describe "is invalid when" do
    it "has no name" do
      expect(build(:campaign, name: nil)).to_not be_valid
    end
  end
end
