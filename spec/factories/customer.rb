require 'factory_girl'

FactoryGirl.define do
  factory :customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.safe_email
    phone Faker::PhoneNumber.phone_number
    association :address, strategy: :build
  end
end
