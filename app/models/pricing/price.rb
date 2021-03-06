class Pricing::Price < ActiveRecord::Base
  belongs_to :period
  belongs_to :organization
  has_many :apartment_prices
  has_many :apartments, :through => :apartment_prices

  monetize :amount_cents, :numericality => {:greater_than => 0}, :as => :amount

  validates_presence_of :period
  validates_presence_of :number_of_night
  validates_presence_of :organization
  validates_numericality_of :number_of_night, :greater_than => 0, :only_integer => true
end
