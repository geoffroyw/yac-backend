require 'rails_helper'

RSpec.describe Pricing::Period, type: :model do
  describe 'it validates presence of name' do
    it { should validate_presence_of :name }
  end

  describe 'it validates that start_date is before end_date' do
    it 'should not be valid if end_date is before start_date' do
      @period = Pricing::Period.new(start_date: Date.today, end_date: (Date.today - 1.day))
      @period.valid?
      expect(@period.errors.full_messages).to include('End date can not be before the start date')
    end

    it 'should not be valid if end_date is equal to start_date' do
      @period = Pricing::Period.new(start_date: Date.today, end_date: Date.today)
      @period.valid?
      expect(@period.errors.full_messages).to include('End date can not be the same as the start date')
    end
  end
end
