require 'rails_helper'

RSpec.describe RentalsController, type: :controller do
  describe 'Customers API' do

    describe '#index' do
      let(:expected_rentals) { Rental.all }

      before :each do
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the customers in JSON' do
        body = JSON.parse(response.body)

        expect(body['rentals']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(expected_rentals).to_json))

      end
    end
  end
end
