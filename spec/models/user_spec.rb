require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'it validates presence of username' do
    it { should validate_presence_of(:username) }
  end
end
