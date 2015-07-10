require 'factory_girl'

FactoryGirl.define do
  factory :apartment_price, :class => Pricing::ApartmentPrice do
    association :apartment, :class => Apartment::Apartment
    association :price, :class => Pricing::Price
  end
end
