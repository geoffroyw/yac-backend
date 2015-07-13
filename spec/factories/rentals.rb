FactoryGirl.define do
  factory :rental do
    start_date Faker::Date.between(Date.today, Date.today+4.days)
    end_date Faker::Date.between(Date.today+5.days, Date.today+40.days)
    number_of_adult 1
    number_of_children 1
    association :organization

    factory :with_customer_and_apartment do
      association :customer, factory: :customer
      association :apartment, factory: :apartment
    end
  end

end
