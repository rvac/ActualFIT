FactoryGirl.define do
  factory :inspection do

    association :campaign

    status "active"
    sequence(:name) {|n| "Inspection #{n}"}
    comment { Faker::Lorem.sentence(Random.rand(0..2)).chomp('.') }

    factory :invalid_inspection do
      name nil
    end
  end
end