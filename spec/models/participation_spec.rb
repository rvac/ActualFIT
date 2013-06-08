# == Schema Information
#
# Table name: participations
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  inspection_id :integer
#  role          :string(255)
#

require 'spec_helper'

describe Participation do
  pending "add some examples to (or delete) #{__FILE__}"
end
