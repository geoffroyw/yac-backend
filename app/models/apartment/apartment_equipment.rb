class Apartment::ApartmentEquipment < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :equipment

  validates_presence_of :apartment
  validates_presence_of :equipment
end
