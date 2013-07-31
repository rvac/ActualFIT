require 'faker'

FactoryGirl.define do
  factory :user do
    #ignore do
    #  insp = :all
    #end
    name { Faker::Name.name }
    email { Faker::Internet.email }
    #{n}@example.com"}
    #sequence(:password) {|n| "jd#{n}@example.com"}
    #sequence(:password_confirmation) {|n| "jd#{n}@example.com"}
    password "password"
    password_confirmation "password"
    #by default everyone has roles everywere

    factory :invalid_user do
      email "is@invalid"
    end

    #factory :admin do
    #  ignore do
    #    insp = :all
    #  end
    #  after(:create) { |user| user.add_role(:admin, insp) }
    #end
    #factory :moderator do
    #  after(:create) { |user| user.add_role(:moderator, insp) }
    #end
    #factory :supervisor do
    #  after(:create) { |user| user.add_role(:supervisor, insp) }
    #end
    #factory :author do
    #  after(:create) { |user| user.add_role(:author, insp) }
    #end
    #factory :inspector do
    #  after(:create) { |user| user.add_role(:inspector, insp) }
    #end

  end
end