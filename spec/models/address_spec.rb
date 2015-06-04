require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'it belongs to a country' do
    it { should belong_to(:country)}
  end

  describe 'it belongs to a customer' do
    it { should belong_to(:customer)}
  end

  describe 'it should validate presence of country' do
    it { should validate_presence_of(:country)}
  end

  describe 'it validates presence of address' do
    it { should validate_presence_of(:address) }
  end

  describe 'it validates presence of postal_code' do
    it { should validate_presence_of(:postal_code) }
  end

  describe 'it validates presence of city' do
    it { should validate_presence_of(:city) }
  end

end
