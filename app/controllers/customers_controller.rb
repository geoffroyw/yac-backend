class CustomersController < ActionController::API

  include ActionController::Serialization

  def index
    customers = Customer.all
    render json: customers, each_serializer: CustomerSerializer
  end
end
