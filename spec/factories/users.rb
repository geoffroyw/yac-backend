FactoryGirl.define do
  factory :user_without_organization, :class => User do
    username Faker::Name.name
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    unconfirmed_email { Faker::Internet.email }
    factory :user do
      association :organization
    end
  end

end
