class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :phone, :email, :created_at, :updated_at
end
