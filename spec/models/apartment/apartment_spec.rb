require 'rails_helper'

RSpec.describe Apartment::Apartment, type: :model do
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

  context 'acts as paranoid' do
    it 'sets deleted_at on deletion' do
      apartment = FactoryGirl.create :apartment
      expect(apartment.deleted_at).to be_nil

      apartment.destroy!
      expect(apartment.deleted_at).not_to be_nil
    end
  end
end
