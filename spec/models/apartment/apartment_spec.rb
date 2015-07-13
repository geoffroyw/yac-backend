require 'rails_helper'

RSpec.describe Apartment::Apartment, type: :model do
  describe 'it has many equipment through apartment equipments' do
    it { should have_many(:equipments).through(:apartment_equipments)}
  end

  describe 'it has many apartment_equipments' do
    it { should have_many :apartment_equipments }
  end

  describe 'it has many rentals' do
    it {should have_many(:rentals)}
  end

  describe 'it validates presence of name' do
    it { should validate_presence_of :name }
  end

  context 'capacity validation' do
    describe 'it validates presence of capacity' do
      it { should validate_presence_of :capacity }
    end

    describe 'it validates that capacity is a integer greater than 0' do
      it { should validate_numericality_of(:capacity).only_integer.is_greater_than(0) }
    end
  end

  describe 'it has many apartment_prices' do
    it { should have_many :apartment_prices }
  end

  describe 'it has many prices through apartment_prices' do
    it { should have_many(:prices).through(:apartment_prices) }
  end

  describe 'it belongs to an organization' do
    it { should belong_to :organization }
  end

  describe 'it validates presence of organization' do
    it { should validate_presence_of :organization}
  end

  context 'acts as paranoid' do
    it 'sets deleted_at on deletion' do
      apartment = FactoryGirl.create :apartment
      expect(apartment.deleted_at).to be_nil

      apartment.destroy!
      expect(apartment.deleted_at).not_to be_nil
    end
  end
end
