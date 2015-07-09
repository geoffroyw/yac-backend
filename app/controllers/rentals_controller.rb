class RentalsController < ApplicationController

  include ActionController::Serialization

  def index
    rentals = Rental.all
    render json: rentals, each_serializer: RentalSerializer
  end

  def show
    rental = Rental.find params[:id]
    if stale?(rental, ast_modified: rental.updated_at)
      render json: rental, serializer: RentalSerializer
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Rental does not exist'}, status: :not_found
  end

  def create
    rental = Rental.new rental_params
    if rental.save
      render json: rental, serializer: RentalSerializer, status: :created
    else
      render json: {errors: rental.errors}, status: :bad_request
    end
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
