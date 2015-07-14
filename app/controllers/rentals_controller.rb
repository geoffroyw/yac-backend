class RentalsController < ApplicationController
  include ActionController::Serialization

  load_and_authorize_resource class: Rental

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Rental does not exist'}, status: :not_found
  end
  
  def index
    render json: @rentals, each_serializer: RentalSerializer
  end

  def show
    if stale?(@rental, ast_modified: @rental.updated_at)
      render json: @rental, serializer: RentalSerializer
    end
  end

  def create
    rental = Rental.new rental_params
    rental.organization = current_user.organization
    if rental.save
      render json: rental, serializer: RentalSerializer, status: :created
    else
      render json: {errors: rental.errors}, status: :bad_request
    end
  end

  def update
    if @rental.update rental_params
      render json: @rental, serializer: RentalSerializer, status: :ok
    else
      render json: {errors: @rental.errors}, status: :bad_request
    end
  end

  def confirm
    @rental.confirm!
    render json: @rental, serializer: RentalSerializer, status: :ok
  rescue AASM::InvalidTransition
    render json: {error: 'Rental can not be confirmed'}, status: :bad_request
  end

  def cancel
    @rental.cancel!
    render json: @rental, serializer: RentalSerializer, status: :ok
  rescue AASM::InvalidTransition
    render json: {error: 'Rental can not be canceled'}, status: :bad_request
  end

  private
  def rental_params
    p = params.require(:rental).permit(:customer, :apartment, :start_date, :end_date, :number_of_adult, :number_of_children).tap{|whitelisted|
      whitelisted[:customer_id] = whitelisted[:customer] if whitelisted.has_key? :customer
      whitelisted[:apartment_id] = whitelisted[:apartment] if whitelisted.has_key? :apartment
    }
    p.delete(:customer)
    p.delete(:apartment)
    p
  end
end
