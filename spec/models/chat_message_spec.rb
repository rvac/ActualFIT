# == Schema Information
#
# Table name: chat_messages
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  inspection_id :integer
#

require 'spec_helper'

describe ChatMessage do
  describe "is valid when" do
    it "factory is valid" do
      expect(build(:message)).to be_valid
    end
  end

  describe "is invalid when" do
    it "does not belong to a user" do
      expect(build(:message, user_id: nil)).to_not be_valid
    end
    it "has no content" do
      expect(build(:message, content: nil)).to_not be_valid
    end
    it "does not belong to an inspection" do
      expect(build(:message, inspection_id: nil)).to_not be_valid
    end

  end
end
