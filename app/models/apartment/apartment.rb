class Apartment::Apartment < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name
  validates_presence_of :capacity
  validates :capacity, numericality: {only_integer: true, greater_than: 0}
end
