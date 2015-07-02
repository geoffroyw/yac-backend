require 'factory_girl'

FactoryGirl.define do
  factory :apartment, :class => Apartment::Apartment do
    name Faker::Commerce.product_name
    capacity Faker::Number.number(2)
    description Faker::Lorem.paragraph
  end
end
