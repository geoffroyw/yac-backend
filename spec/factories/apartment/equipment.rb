FactoryGirl.define do
  factory :equipment, :class => Apartment::Equipment do
    name Faker::Commerce.product_name
    description Faker::Lorem.paragraph
    association :organization
  end

end
