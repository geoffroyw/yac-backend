class Pricing::PriceSerializer < ActiveModel::Serializer
  attributes :id, :number_of_night, :amount_cents, :amount_currency

  has_one :period, key: :period, serializer: Pricing::PeriodSerializer, embed: :objects
end
