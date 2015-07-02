class Apartment::ApartmentsController < ApplicationController

  include ActionController::Serialization

  def index
    apartments = Apartment::Apartment.all
    render json: apartments, each_serializer: Apartment::ApartmentSerializer
  end

  def show
    apartment = Apartment::Apartment.find params[:id]
    if stale?(apartment, last_modified: apartment.updated_at)
      render json: apartment, serializer: Apartment::ApartmentSerializer
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Apartment does not exist'}, status: :not_found
  end
end
