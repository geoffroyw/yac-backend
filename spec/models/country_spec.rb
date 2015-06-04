require 'rails_helper'

RSpec.describe Country, type: :model do
  describe 'it has many addresses' do
    it { should have_many(:addresses) }
  end

  describe 'it validates presence of name' do
    it { should validate_presence_of(:name) }
  end
end
