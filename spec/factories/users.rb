FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "John Doe #{n}"}
    sequence(:email) {|n| "jd#{n}@example.com"}
    #sequence(:password) {|n| "jd#{n}@example.com"}
    #sequence(:password_confirmation) {|n| "jd#{n}@example.com"}
    password "jd@example.com"
    password_confirmation "jd@example.com"
  end
end