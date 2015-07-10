class Pricing::PricesController < ApplicationController
  include ActionController::Serialization

  def index
    prices = Pricing::Price.all
    render json: prices, each_serializer: Pricing::PriceSerializer
  end

  def show
    price = Pricing::Price.find params[:id]
    if stale?(price, last_modified: price.updated_at)
      render json: price, serializer: Pricing::PriceSerializer
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Price does not exist'}, status: :not_found
  end
end
