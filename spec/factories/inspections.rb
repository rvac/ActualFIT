FactoryGirl.define do
  factory :inspection do

    association :campaign

    status "active"
    sequence(:name) {|n| "Inspection #{n}"}
    sequence(:comment) {|n| "Comment for inspection #{n}"}

  end
end