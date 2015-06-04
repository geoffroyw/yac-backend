class Customer < ActiveRecord::Base
  has_one :address

  validates_presence_of :first_name
  validates_presence_of :last_name
end
