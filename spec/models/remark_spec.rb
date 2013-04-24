# == Schema Information
#
# Table name: remarks
#
#  id            :integer          not null, primary key
#  location      :string(255)
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
  pending "add some examples to (or delete) #{__FILE__}"
end
