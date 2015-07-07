require 'rails_helper'

RSpec.describe Apartment::ApartmentEquipment, type: :model do
  describe 'it belongs to apartment' do
    it { should belong_to :apartment }
  end

  describe 'it belongs to equipment' do
    it { should belong_to :equipment }
  end

  describe 'it validates presence of equipment' do
    it { should validate_presence_of :equipment }
  end

  describe 'it validates presence of apartment' do
    it { should validate_presence_of :apartment }
  end
end
