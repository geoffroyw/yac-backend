class CustomersController < ApplicationController
  include ActionController::Serialization

  before_filter :fetch_address_with_customer, :only => :show


  load_and_authorize_resource class: Customer

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Customer does not exist'}, status: :not_found
  end

  def index
    @customers = @customers.includes(:address).all
    render json: @customers, each_serializer: CustomerSerializer
  end

  def show
    if stale?(@customer, ast_modified: @customer.updated_at)
      render json: @customer, serializer: CustomerSerializer
    end
  end


  def create
    customer = Customer.new customer_params
    customer.organization = current_user.organization
    if customer.save
      render json: customer, serializer: CustomerSerializer, status: :created
    else
      render json: {errors: customer.errors}, status: :bad_request
    end
  end

  def update
    if @customer.update customer_params
      render json: @customer, serializer: CustomerSerializer, status: :ok
    else
      render json: {errors: @customer.errors}, status: :bad_request
    end
  end

  private

  def customer_params
    params.require(:customer)
        .permit(:first_name, :last_name, :email, :phone,
                address_attributes: [:customer_id, :address, :address2, :postal_code, :city, :country_id]
        )
  end

  def fetch_address_with_customer
    @customer = Customer.includes(:address).find(params[:id])
  end
end
