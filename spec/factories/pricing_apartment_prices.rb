FactoryGirl.define do
  factory :pricing_apartment_price, :class => 'Pricing::ApartmentPrice' do
    association :apartment
    association :price
  end

end
