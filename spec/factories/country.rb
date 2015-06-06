require 'factory_girl'

FactoryGirl.define do
  factory :country do
    sequence :name do |n|
      "country#{n}"
    end
    sequence :iso do |n|
      "iso#{n}"
    end
  end
end