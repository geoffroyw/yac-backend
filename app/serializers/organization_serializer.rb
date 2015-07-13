class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :users, key: :users
  has_one :admin, key: :admin
end
