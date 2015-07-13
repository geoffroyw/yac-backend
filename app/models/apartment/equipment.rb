class Apartment::Equipment < ActiveRecord::Base
  has_many :apartment_equipments
  has_many :apartments, :through => :apartment_equipments
  belongs_to :organization

  validates_presence_of :name
  validates_presence_of :organization
end
