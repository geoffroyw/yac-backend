# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  first_name :string(255)      not null
#  last_name  :string(255)      not null
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  has_one :address, :inverse_of => :customer
  has_many :rentals

  validates_presence_of :first_name
  validates_presence_of :last_name

  accepts_nested_attributes_for :address
end
