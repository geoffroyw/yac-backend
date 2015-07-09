class RentalsController < ApplicationController

  include ActionController::Serialization

  def index
    rentals = Rental.all
    render json: rentals, each_serializer: RentalSerializer
  end
end
