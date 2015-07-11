class Rental < ActiveRecord::Base
  include AASM

  belongs_to :customer
  belongs_to :apartment, :class_name => 'Apartment::Apartment'

  validates_presence_of :customer
  validates_presence_of :apartment
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :number_of_adult
  validates_numericality_of :number_of_adult, :greater_than_or_equal_to => 1, :only_integer => true
  validates_numericality_of :number_of_children, :greater_than_or_equal_to => 0, :only_integer => true

  validate :no_capacity_overflow
  validate :end_date_cannot_be_before_start_date
  validate :end_date_cannot_be_in_past
  validate :start_date_cannot_be_in_past
  validate :an_apartment_can_only_be_booked_once_on_a_given_timeframe

  before_validation :default_values

  aasm :column => :state, :skip_validation_on_save => true do
    state :draft, :initial => true
    state :confirmed
    state :canceled

    event :confirm do
      transitions :from => :draft, :to => :confirmed
    end

    event :cancel do
      transitions :from => [:draft, :confirmed], :to => :canceled
    end
  end

  private

  def end_date_cannot_be_before_start_date
    unless start_date.blank? || end_date.blank?
      errors.add(:end_date, 'can not be before the start date') if end_date < start_date
      errors.add(:end_date, 'can not be the same as the start date') if end_date == start_date
    end
  end

  def end_date_cannot_be_in_past
    unless end_date.blank?
      errors.add(:end_date, 'can not be in the past') if end_date < Date.today
    end
  end

  def start_date_cannot_be_in_past
    unless start_date.blank?
      errors.add(:start_date, 'can not be in the past') if start_date < Date.today
    end
  end

  def no_capacity_overflow
    unless number_of_adult.nil? || apartment.nil?
      errors.add(:number_of_people, 'can not be greater than the apartment\'s capacity') if number_of_adult+number_of_children > apartment.capacity
    end
  end

  def an_apartment_can_only_be_booked_once_on_a_given_timeframe
    unless apartment.nil? || start_date.nil? || end_date.nil?
      rental_count = Rental.where('state != :state AND (start_date <= :start_date AND end_date > :start_date) OR (start_date <= :end_date AND end_date > :end_date)', {start_date: start_date, end_date: end_date, state: 'canceled'}).count
      errors.add(:apartment, 'is already booked') if rental_count > 0
    end
  end

  def default_values
    self.number_of_children ||= 0
  end
end
