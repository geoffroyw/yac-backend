class CustomersController < ActionController::API

  include ActionController::Serialization

  def index
    customers = Customer.all
    render json: customers, each_serializer: CustomerSerializer
  end

  def show
    customer = Customer.find params[:id]
    if stale?(customer, ast_modified: customer.updated_at)
      render json: customer, serializer: CustomerSerializer
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Customer does not exist'}, status: :not_found
  end


  def create
    customer = Customer.new customer_params
    if customer.save
      render json: customer, serializer: CustomerSerializer, status: :created
    else
      render json: {errors: customer.errors}, status: :bad_request
    end
  end


  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone)
  end
end
