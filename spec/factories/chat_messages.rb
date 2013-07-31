FactoryGirl.define do
  factory :ChatMessage, class: ChatMessage do
    association :user
    association :inspection

    content { Faker::Lorem.sentence(Random.rand(2..5)).chomp('.') }

    factory :invalid_message do
      content nil
    end
  end
end