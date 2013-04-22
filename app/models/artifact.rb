# == Schema Information
#
# Table name: artifacts
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  comment       :string(255)
#  inspection_id :integer
#  file          :binary(52428800)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Artifact < ActiveRecord::Base
  attr_accessible :comment, :inspection_id, :name
  belogs_to :inspection

  validates :inspection_id, presence: false
  validates :name, presence: true
end
