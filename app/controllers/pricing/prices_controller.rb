class Pricing::PricesController < ApplicationController
  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Price does not exist'}, status: :not_found
  end

  def index
    prices = Pricing::Price.all
    render json: prices, each_serializer: Pricing::PriceSerializer
  end

  def show
    price = Pricing::Price.find params[:id]
    if stale?(price, last_modified: price.updated_at)
      render json: price, serializer: Pricing::PriceSerializer
    end
  end

  def create
    price = Pricing::Price.new price_params
    if price.save
      render json: price, serializer: Pricing::PriceSerializer, status: :created
    else
      render json: {errors: price.errors}, status: :bad_request
    end
  end

  def update
    price = Pricing::Price.find params[:id]
    if price.update price_params
      render json: price, serializer: Pricing::PriceSerializer, status: :ok
    else
      render json: {errors: price.errors}, status: :bad_request
    end
  end

  private
  def price_params
    params.require(:price).permit(:number_of_night, :amount_cents, :amount_currency, :period_id)
  end
end
