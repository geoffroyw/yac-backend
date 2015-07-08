require 'factory_girl'

FactoryGirl.define do
  factory :apartment_equipment, :class => Apartment::ApartmentEquipment do
    association :apartment
    association :equipment
  end
end
