class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address, :address2, :postal_code, :country_id, :city

  has_one :country, key: :country
end
