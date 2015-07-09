class RentalSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :state, :number_of_adult, :number_of_children, :created_at, :updated_at

  has_one :customer, key: :customer
  has_one :apartment, key: :apartment
end
