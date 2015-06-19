require 'factory_girl'

FactoryGirl.define do
  factory :address do
    address Faker::Address.street_address
    address2 Faker::Address.secondary_address
    postal_code Faker::Address.zip_code
    city Faker::Address.city
    country
  end
end