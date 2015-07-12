class CustomersController < ActionController::API
  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Customer does not exist'}, status: :not_found
  end

  def index
    customers = Customer.includes(:address).all
    render json: customers, each_serializer: CustomerSerializer
  end

  def show
    customer = Customer.includes(:address).find params[:id]
    if stale?(customer, ast_modified: customer.updated_at)
      render json: customer, serializer: CustomerSerializer
    end
  end


  def create
    customer = Customer.new customer_params
    if customer.save
      render json: customer, serializer: CustomerSerializer, status: :created
    else
      render json: {errors: customer.errors}, status: :bad_request
    end
  end

  def update
    customer = Customer.find params[:id]
    if customer.update customer_params
      render json: customer, serializer: CustomerSerializer, status: :ok
    else
      render json: {errors: customer.errors}, status: :bad_request
    end
  end

  private

  def customer_params
    params.require(:customer)
        .permit(:first_name, :last_name, :email, :phone,
                address_attributes: [:customer_id, :address, :address2, :postal_code, :city, :country_id]
        )
  end
end
