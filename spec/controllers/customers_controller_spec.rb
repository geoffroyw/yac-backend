require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'Customers API' do
    it 'retrieves the list of customers' do

      c1 = FactoryGirl.create :customer
      c2 = FactoryGirl.create :customer

      expected_customers = [c1, c2]

      get 'index'


      # test for the 200 status-code
      expect(response).to be_success

      customers_from_api = JSON.parse(response.body)

      expect(customers_from_api).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(expected_customers).to_json))


    end
  end
end
