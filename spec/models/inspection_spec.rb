# == Schema Information
#
# Table name: inspections
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  comment            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  inspection_team_id :integer
#  campaign_id        :integer
#  status             :string(255)
#

require 'spec_helper'

describe Inspection do
  pending "add some examples to (or delete) #{__FILE__}"
end
