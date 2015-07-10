class Pricing::ApartmentPrice < ActiveRecord::Base
  belongs_to :price
  belongs_to :apartment, class_name: Apartment::Apartment

  validates_presence_of :price
  validates_presence_of :apartment
end
