class Apartment::ApartmentsController < ApplicationController

  include ActionController::Serialization

  def index
    apartments = Apartment::Apartment.all
    render json: apartments, each_serializer: Apartment::ApartmentSerializer

  end
end
