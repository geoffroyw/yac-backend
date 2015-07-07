require 'rails_helper'

RSpec.describe Apartment::Equipment, type: :model do
  describe 'it has many apartments through apartment_equioments' do
    it { should have_many(:apartments).through(:apartment_equipments) }
  end

  describe 'it has many apartment_equipments' do
    it { should have_many :apartment_equipments }
  end

  describe 'it validates presence of name' do
    it { should validate_presence_of :name }
  end

end
