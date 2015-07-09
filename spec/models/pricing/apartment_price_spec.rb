require 'rails_helper'

RSpec.describe Pricing::ApartmentPrice, type: :model do
  describe 'it belongs to apartment' do
    it { should belong_to :apartment }
  end

  describe 'it belongs to price' do
    it { should belong_to :price }
  end

  describe 'it validates presence of price' do
    it { should validate_presence_of :price }
  end

  describe 'it validates presence of apartment' do
    it { should validate_presence_of :apartment }
  end
end
