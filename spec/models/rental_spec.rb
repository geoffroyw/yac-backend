require 'rails_helper'

RSpec.describe Rental, type: :model do
  describe 'it belongs to customer' do
    it {should belong_to(:customer)}
  end

  describe 'it belongs to apartment' do
    it {should belong_to(:apartment)}
  end

  describe 'it validates presence of customer' do
    it {should validate_presence_of(:customer)}
  end

  describe 'it validates presence of apartment' do
    it {should validate_presence_of(:apartment)}
  end

  describe 'it validates presence of start_date' do
    it {should validate_presence_of(:start_date)}
  end

  describe 'it validates presence of end_date' do
    it {should validate_presence_of(:end_date)}
  end

  describe 'it validates presence of number_of_adult' do
    it {should validate_presence_of(:number_of_adult)}
  end

  describe 'it validates that number_of_adult is a integer greater or equal to 1' do
    it { should validate_numericality_of(:number_of_adult).only_integer.is_greater_than_or_equal_to(1) }
  end

  describe 'it validates that number_of_children is a integer greater or equal to 1' do
    it { should validate_numericality_of(:number_of_children).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'it validates that the total number of people can not be greater than the apartment capacity' do
    before(:each) do
      @apartment = Apartment::Apartment.new(:capacity => 4)
    end

    it 'should not be valid if there is more adult than the capacity of the apartment' do
      @rental = Rental.new(number_of_adult: 5, apartment: @apartment)
      @rental.valid?
      expect(@rental.errors.full_messages).to include('Number of people can not be greater than the apartment\'s capacity')
    end

    it 'should not be valid if nb_adult + nb_children is greater than the capacity of the apartment' do
      @rental = Rental.new(number_of_adult: 2, number_of_children: 3, apartment: @apartment)
      @rental.valid?
      expect(@rental.errors.full_messages).to include('Number of people can not be greater than the apartment\'s capacity')
    end

  end

  describe 'it validates that start_date is before end_date' do
    it 'should not be valid if end_date is before start_date' do
      @rental = Rental.new(start_date: Date.today, end_date: (Date.today - 1.day))
      @rental.valid?
      expect(@rental.errors.full_messages).to include('End date can not be before the start date')
    end

    it 'should not be valid if end_date is equal to start_date' do
      @rental = Rental.new(start_date: Date.today, end_date: Date.today)
      @rental.valid?
      expect(@rental.errors.full_messages).to include('End date can not be the same as the start date')
    end
  end

  describe 'it validates that dates can not be in past' do
    it 'should not be valid if end_date is in past' do
      @rental = Rental.new(start_date: Date.today, end_date: (Date.today - 1.day))
      @rental.valid?
      expect(@rental.errors.full_messages).to include('End date can not be in the past')
    end

    it 'should not be valid if end_date is equal to start_date' do
      @rental = Rental.new(start_date: Date.today- 10.days, end_date: Date.today+20.days)
      @rental.valid?
      expect(@rental.errors.full_messages).to include('Start date can not be in the past')
    end
  end

  describe 'it has a state machine' do
    it 'has draft as initial state' do
      @rental = Rental.new
      expect(@rental.draft?).to be true
    end

    it 'can transition from draft to confirmed' do
      @rental = Rental.new
      @rental.confirm
      expect(@rental.confirmed?).to be true
    end

    it 'can transition from draft to cancel' do
      @rental = Rental.new
      @rental.cancel
      expect(@rental.canceled?).to be true
    end

    it 'can transition from confirmed to cancel' do
      @rental = Rental.new
      @rental.confirm
      @rental.cancel
      expect(@rental.canceled?).to be true
    end

    it 'cannot transition from cancel to confirmed' do
      @rental = Rental.new
      @rental.cancel
      expect{@rental.confirm}.to raise_error(AASM::InvalidTransition)
    end
  end

end
