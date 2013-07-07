# == Schema Information
#
# Table name: inspections
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  comment     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campaign_id :integer
#  status      :string(255)
#

require 'spec_helper'

describe Inspection do
  describe "is valid when" do
    it "factory is valid" do
      expect(build(:inspection)).to be_valid
    end
  end
  describe "is invalid when" do
    it "has no name" do
      expect(build(:inspection, name: nil)).to_not be_valid
    end

    it "has no status" do
      expect(build(:inspection, status: nil)).to_not be_valid
    end
  end

end
