class User::OrganizationsController < ApplicationController
  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Organization does not exist'}, status: :not_found
  end

  def show
    organization = Organization.find params[:id]
    if stale?(organization, last_modified: organization.updated_at)
      render json: organization, serializer: OrganizationSerializer
    end
  end

  def create
    organization = Organization.new organization_params
    organization.admin = current_user
    organization.users << current_user
    if organization.save
      render json: organization, serializer: OrganizationSerializer, status: :created
    else
      render json: {errors: organization.errors}, status: :bad_request
    end
  end

  def update
    organization = Organization.find params[:id]
    if organization.update organization_params
      render json: organization, serializer: OrganizationSerializer, status: :ok
    else
      render json: {errors: organization.errors}, status: :bad_request
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:name, :admin, :users)
  end
end
