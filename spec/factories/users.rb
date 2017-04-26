FactoryGirl.define do
  factory :user do
    password '123456'
    password_confirmation '123456'
    username { FFaker::Name.name }
    sequence(:email) { |n| "email_#{n}@fake.com" }
  end
end
