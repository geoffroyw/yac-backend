FactoryGirl.define do
  factory :rental do
    start_date Faker::Date.between(Date.today, Date.today+7.days)
    end_date Faker::Date.forward(8)
    number_of_adult 1
    number_of_children 1
  end

end
