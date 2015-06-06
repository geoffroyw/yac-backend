# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  iso        :string(255)      not null
#

class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :iso
end
