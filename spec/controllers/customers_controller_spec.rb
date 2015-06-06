require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'Customers API' do
    it 'retrieves the list of customers' do

      c1 = FactoryGirl.create :customer
      c2 = FactoryGirl.create :customer

      expected_customers = [c1.reload, c2.reload]

      get 'index'


      # test for the 200 status-code
      expect(response).to be_success

      body = JSON.parse(response.body)

      expect(body['customers']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(expected_customers).to_json))


    end
  end
end
