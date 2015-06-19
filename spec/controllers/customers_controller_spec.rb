require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'Customers API' do

    describe '#index' do
      let(:expected_customers) {Customer.all}

      before :each do
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the customers in JSON' do
        body = JSON.parse(response.body)

        expect(body['customers']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(expected_customers).to_json))

      end

    end
  end
end
