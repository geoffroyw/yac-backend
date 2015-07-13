require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'it validates presence of username' do
    it { should validate_presence_of(:username) }
  end

  describe 'it belongs to an organization' do
    it {should belong_to :organization}
  end

  describe 'it has one own_organization' do
    it {should have_one :own_organization}
  end
end
