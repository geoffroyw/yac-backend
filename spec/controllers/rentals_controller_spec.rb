require 'rails_helper'

RSpec.describe RentalsController, type: :controller do
  describe 'Rentals API' do

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

    describe '#show' do
      let(:expected_rental) { FactoryGirl.create :with_customer_and_apartment }

      context 'when the rental is found' do
        before :each do
          get :show, {:id => expected_rental.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the rental in JSON' do
          body = JSON.parse(response.body)
          rental = body['rental']

          expect(rental['id']).to eq(expected_rental.id)
          expect(rental['apartment']).to eq(expected_rental.apartment.id)
          expect(rental['customer']).to eq(expected_rental.customer.id)
          expect(rental['state']).to eq(expected_rental.state)
          expect(rental['start_date']).to eq(expected_rental.start_date.to_s)
          expect(rental['end_date']).to eq(expected_rental.end_date.to_s)

        end
      end

      context 'when the rental is not found' do
        it 'responds with 404' do
          get :show, {:id => 2}
          expect(response).to be_not_found
        end
      end
    end
  end
end
