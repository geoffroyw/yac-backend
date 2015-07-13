require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'it belongs to an admin' do
    it { should belong_to(:admin) }
  end

  describe 'it has many users' do
    it {should have_many :users}
  end

  describe 'it validates presence of name' do
    it { should validate_presence_of :name }
  end


  describe 'it validates presence of admin' do
    it { should validate_presence_of :admin }
  end
end
