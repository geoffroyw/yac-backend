class Apartment::ApartmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :capacity
end
