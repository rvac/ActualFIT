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
#  filename      :string(255)
#  content_type  :string(255)
#  user_id       :integer
#

FactoryGirl.define do
  factory :artifact do

    association :user
    association :inspection


    sequence(:name) {|n| "artifact #{n}"}
    sequence(:comment) {|n| "Comment for artifact #{n}"}
  end
end