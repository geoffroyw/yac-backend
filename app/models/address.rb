class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :customer

  validates_presence_of :address
  validates_presence_of :postal_code
  validates_presence_of :city
  validates_presence_of :country
end
