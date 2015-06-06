require 'factory_girl'

FactoryGirl.define do
  factory :country do
    sequence :name do |n|
      "country#{n}"
    end
    sequence :name do |n|
      "country#{n}"
    end
  end
end