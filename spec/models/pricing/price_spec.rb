require 'rails_helper'

RSpec.describe Pricing::Price, type: :model do
  describe 'it belongs to an organization' do
    it { should belong_to :organization }
  end

  describe 'it validates presence of organization' do
    it { should validate_presence_of :organization}
  end

  describe 'it monetize amount' do
    it { should monetize(:amount_cents).as(:amount) }
  end

  describe 'it validates numericality of amout' do
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe 'it validates presence of period' do
    it { should validate_presence_of :period }
  end

  describe 'it validates presence of number_of_night' do
    it { should validate_presence_of :number_of_night }
  end

  describe 'it validates numericality of number of night' do
    it { should validate_numericality_of(:number_of_night).only_integer.is_greater_than(0) }
  end

  describe 'it belongs to period' do
    it { should belong_to :period }
  end

  describe 'it has many apartment_prices' do
    it { should have_many :apartment_prices }
  end

  describe 'it has many apartments through apartment_prices' do
    it { should have_many(:apartments).through(:apartment_prices) }
  end
end
