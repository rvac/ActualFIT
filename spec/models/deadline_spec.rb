# == Schema Information
#
# Table name: deadlines
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  comment    :string(255)
#  startDate  :datetime
#  endDate    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Deadline do
  pending "add some examples to (or delete) #{__FILE__}"
end
