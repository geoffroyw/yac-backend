require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'it should have one address' do
    it {should have_one(:address)}
  end

  describe 'it validates presence of first_name' do
    it { should validate_presence_of(:first_name) }
  end

  describe 'it validates presence of last_name' do
    it { should validate_presence_of(:last_name) }
  end
end
