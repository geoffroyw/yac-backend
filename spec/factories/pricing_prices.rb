FactoryGirl.define do
  factory :price, :class => 'Pricing::Price' do
    association :period
    number_of_night Faker::Number.number(2)
    amount_cents Faker::Commerce.price
    association :organization
  end

end
