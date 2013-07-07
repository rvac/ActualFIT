FactoryGirl.define do
  factory :campaign do

    sequence(:name) {|n| "Campaign #{n}"}
    sequence(:comment) {|n| "Comment for campaign #{n}"}
  end
end