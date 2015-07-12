class Apartment::ApartmentsController < ApplicationController

  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Apartment does not exist'}, status: :not_found
  end

  def index
    apartments = Apartment::Apartment.includes(:equipments).all
    render json: apartments, each_serializer: Apartment::ApartmentSerializer
  end

  def show
    apartment = Apartment::Apartment.includes(:equipments).find params[:id]
    if stale?(apartment, last_modified: apartment.updated_at)
      render json: apartment, serializer: Apartment::ApartmentSerializer
    end
  end

  def create
    apartment = Apartment::Apartment.new apartment_params
    if apartment.save
      render json: apartment, serializer: Apartment::ApartmentSerializer, status: :created
    else
      render json: {errors: apartment.errors}, status: :bad_request
    end
  end

  def update
    apartment = Apartment::Apartment.find params[:id]
    if apartment.update apartment_params
      render json: apartment, serializer: Apartment::ApartmentSerializer, status: :ok
    else
      render json: {errors: apartment.errors}, status: :bad_request
    end
  end

  def destroy
    apartment = Apartment::Apartment.find params[:id]
    if apartment.delete
      render json: [] , status: :no_content
    else
      render json: {errors: 'Error while deleting apartment'}, status: :bad_request
    end
  end

  private

  def apartment_params
    hash = params.require(:apartment)
        .permit(:name, :description, :capacity, :equipments => []).tap{|whitelisted| whitelisted[:equipment_ids] = whitelisted[:equipments] if whitelisted.has_key? :equipments}
    hash.delete(:equipments)
    hash
  end
end
