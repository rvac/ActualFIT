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
#

class Location < ActiveRecord::Base
  belongs_to :remark


  attr_accessible :description, :element_type, :element_number, :element_name, :line_number, :diagram, :path
end
