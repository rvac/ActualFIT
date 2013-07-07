FactoryGirl.define do
  factory :message, class: ChatMessage do
    association :user
    association :inspection

    sequence(:content) {|n| "content here #{n}"}

  end
end