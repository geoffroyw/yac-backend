class Apartment::Equipment < ActiveRecord::Base
  has_many :apartment_equipments
  has_many :apartments, :through => :apartment_equipments

  validates_presence_of :name
end
