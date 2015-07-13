FactoryGirl.define do
  factory :organization do
    name Faker::Commerce.product_name
    association :admin, factory: :user_without_organization

    transient do
      users_count 5
    end

    after(:create) do |organization, evaluator|
      create_list(:user, evaluator.users_count, organization: organization)
    end
  end

end
