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
end
