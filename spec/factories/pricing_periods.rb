FactoryGirl.define do
  factory :period, :class => 'Pricing::Period' do
    start_date Faker::Date.between(Date.today, Date.today+4.days)
    end_date Faker::Date.between(Date.today+5.days, Date.today+40.days)
    name Faker::Commerce.product_name
  end

end
