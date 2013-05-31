# == Schema Information
#
# Table name: participations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Participation < ActiveRecord::Base
  #attr_accessible :name, :user_id
  belongs_to :inspection
  belongs_to :user

end
