# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string(255)
#

require 'spec_helper'

describe Campaign do
  describe "is valid when" do
    it "has valid factory" do
      expect(create(:campaign)).to be_valid
    end

    it "has valid factory with users" do
      expect(create(:campaign_with_users)).to be_valid
      #expect to have more that 1 inspection
      #expect to have more than 1 remark & 1 coment for every inspection
    end
  end

  it "has inspections" do
    expect(create(:campaign)).to have_at_least(1).inspections
  end
  it "has at least 3 users" do
    inspection = create(:campaign_with_users).inspections.first
    expect(inspection).to have_at_least(3).users
  end
  describe "is invalid when" do
    it "has no name" do
      expect(create(:campaign, name: nil)).to_not be_valid
    end
  end

end
