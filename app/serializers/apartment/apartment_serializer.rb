class Apartment::ApartmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :capacity

  has_many :equipments, key: :equipments
  has_many :prices, key: :prices

end
