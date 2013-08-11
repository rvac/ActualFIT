# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  remark_id      :integer
#  description    :string(255)
#  element_type   :string(255)
#  element_number :string(255)
#  element_name   :string(255)
#  diagram        :string(255)
#  path           :string(255)
#  line_number    :integer
#  type           :string(255)
#

require 'spec_helper'

describe Location do
  pending "add some examples to (or delete) #{__FILE__}"
end
