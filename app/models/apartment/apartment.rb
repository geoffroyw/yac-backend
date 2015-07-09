class Apartment::Apartment < ActiveRecord::Base
  acts_as_paranoid

  has_many :rentals
  has_many :apartment_equipments
  has_many :equipments, :through => :apartment_equipments
  has_many :apartment_prices, :class_name => Pricing::ApartmentPrice
  has_many :prices, :through => :apartment_prices, :class_name => Pricing::Price

  validates_presence_of :name
  validates_presence_of :capacity
  validates :capacity, numericality: {only_integer: true, greater_than: 0}
end
