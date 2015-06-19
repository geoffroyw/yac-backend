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
end
