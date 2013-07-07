FactoryGirl.define do
  factory :remark, class: Remark do
    association :user
    association :inspection
    #association :artifact

    remark_type  "major"
    sequence(:location) {|n| "line number #{n}"}
    sequence(:content) {|n| "content here #{n}"}

  end
end