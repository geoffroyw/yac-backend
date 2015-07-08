require 'factory_girl'

FactoryGirl.define do
  factory :apartment, :class => Apartment::Apartment do
    name Faker::Commerce.product_name
    capacity Faker::Number.number(2)
    description Faker::Lorem.paragraph

    factory :apartment_with_equipments do
      transient do
        equipments_count 5
      end

      after(:create) do |apartment, evaluator|
        create_list(:apartment_equipment, evaluator.equipments_count, apartment: apartment)
      end
    end
  end
end
