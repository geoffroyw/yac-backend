# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Country, type: :model do
  describe 'it has many addresses' do
    it { should have_many(:addresses) }
  end

  describe 'it validates presence of name' do
    it { should validate_presence_of(:name) }
  end
end
