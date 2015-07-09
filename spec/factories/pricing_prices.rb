FactoryGirl.define do
  factory :pricing_price, :class => 'Pricing::Price' do
    period_id 1
number_of_night 1
amount "9.99"
currency_id 1
  end

end
