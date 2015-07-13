FactoryGirl.define do
  factory :organization do
    name Faker::Commerce.product_name
    association :admin, factory: :user
  end

end
