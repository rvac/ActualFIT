FactoryGirl.define do
  factory :remark, class: Remark do
    association :user
    association :inspection
    #association :artifact
    loc = ['line', 'diagram', 'picture', 'figure', 'inspection']
    remark_type  "major"
    #location "#{loc[Random.rand(0..5)]} #{Random.rand(1..100)}"
    sequence(:location) {|n| "line #{n}"}
    content { Faker::Lorem.sentence(Random.rand(1..10)).chomp('.') }

    factory :invalid_remark do
      content nil
    end
  end
end