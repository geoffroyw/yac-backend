class Apartment::EquipmentsController < ApplicationController
  include ActionController::Serialization

  load_and_authorize_resource class: Apartment::Equipment

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Equipment does not exist'}, status: :not_found
  end

  def index
    render json: @equipment, each_serializer: Apartment::EquipmentSerializer
  end

  def show
    if stale?(@equipment, last_modified: @equipment.updated_at)
      render json: @equipment, serializer: Apartment::EquipmentSerializer
    end
  end

  def create
    equipment = Apartment::Equipment.new equipment_params
    equipment.organization = current_user.organization
    if equipment.save
      render json: equipment, serializer: Apartment::EquipmentSerializer, status: :created
    else
      render json: {errors: equipment.errors}, status: :bad_request
    end
  end

  def update
    if @equipment.update equipment_params
      render json: @equipment, serializer: Apartment::EquipmentSerializer, status: :ok
    else
      render json: {errors: @equipment.errors}, status: :bad_request
    end
  end

  def destroy
    if @equipment.delete
      render json: [] , status: :no_content
    else
      render json: {errors: 'Error while deleting equipment'}, status: :bad_request
    end
  end

  private
  def equipment_params
    params.require(:equipment).permit(:name, :description)
  end
end
