# == Schema Information
#
# Table name: remarks
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  user_id       :integer
#  inspection_id :integer
#  remark_type   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  artifact_id   :integer
#

require 'spec_helper'

describe Remark do

  describe "is valid when" do
    it "has valid factory" do
       expect(build(:remark, artifact: nil)).to be_valid
    end
  end

  describe "is invalid when" do
    it "has no user_id" do
      expect(build(:remark, user_id: nil)).to_not be_valid
      end
    it "has no inspection_id" do
      expect(build(:remark, inspection_id: nil)).to_not be_valid
    end
    it "has no content" do
      expect(build(:remark, content: nil)).to_not be_valid
      end
    it "has no location" do
      expect(build(:remark, location: nil)).to_not be_valid
    end
    it "has no remark type" do
      expect(build(:remark, remark_type: nil)).to_not be_valid
    end
  end
end
