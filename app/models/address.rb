# == Schema Information
#
# Table name: addresses
#
#  id          :integer          not null, primary key
#  address     :string(255)      not null
#  address2    :string(255)
#  postal_code :string(255)      not null
#  city        :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#  country_id  :integer          not null
#  customer_id :integer          not null
#

class Address < ActiveRecord::Base
  belongs_to :country
  belongs_to :customer

  validates_presence_of :address
  validates_presence_of :postal_code
  validates_presence_of :city
  validates_presence_of :country
  validates_presence_of :customer
end
