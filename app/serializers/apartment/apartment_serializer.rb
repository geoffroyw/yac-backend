class Apartment::ApartmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :capacity

  has_many :equipments, key: :equipments, serializer: EquipmentIdSerializer

end
