class AddressSerializer < ActiveModel::Serializer
  attributes :id, :address, :address2, :postal_code, :country, :city

  has_one :country, key: :country, embed: :objects
end
