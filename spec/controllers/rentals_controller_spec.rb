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

    describe '#create' do
      context 'when the submitted entity is not valid' do
        it 'responds with 400' do
          post :create, {:rental => {start_date: ''}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_rental) { FactoryGirl.build(:with_customer_and_apartment) }

        before :each do
          post :create, {:rental => submitted_rental.attributes.merge(customer: submitted_rental.customer.id).merge(apartment: submitted_rental.apartment.id)}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates a rental with the given attributes values' do
          id = JSON.parse(response.body)['rental']['id']


          created_rental = Rental.find id
          expect(created_rental.customer).to eq(submitted_rental.customer)
          expect(created_rental.apartment).to eq(submitted_rental.apartment)
          expect(created_rental.start_date).to eq(submitted_rental.start_date)
          expect(created_rental.state).to eq('draft')
          expect(created_rental.end_date).to eq(submitted_rental.end_date)
          expect(created_rental.number_of_adult).to eq(submitted_rental.number_of_adult)
          expect(created_rental.number_of_children).to eq(submitted_rental.number_of_children)
        end
      end
    end

    describe '#update' do
      context 'when the entity does not exists' do
        it 'responds with 404' do
          put :update, {:id => 4.to_s}
          expect(response).to be_not_found
        end
      end

      context 'when the entity is found' do
        let(:rental_to_be_updated) { FactoryGirl.create :with_customer_and_apartment }

        context 'when the submitted parameters are not valid' do
          it 'responds with 400' do
            rental_to_be_updated.number_of_adult = -5
            put :update, {:id => rental_to_be_updated.id.to_s,
                          :rental => rental_to_be_updated.attributes.merge(customer: rental_to_be_updated.customer.id).merge(apartment: rental_to_be_updated.apartment.id)}
            expect(response).to be_bad_request
          end
        end

        context 'when the submitted parameters are valid' do
          it 'responds with 200' do
            rental_to_be_updated.start_date = Date.today + 1.month
            rental_to_be_updated.end_date = Date.today + 1.year
            put :update, {:id => rental_to_be_updated.id.to_s,
                          :rental => rental_to_be_updated.attributes.merge(customer: rental_to_be_updated.customer.id).merge(apartment: rental_to_be_updated.apartment.id)}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            rental_to_be_updated.start_date = Date.today + 1.month
            rental_to_be_updated.end_date = Date.today + 1.year
            put :update, {:id => rental_to_be_updated.id.to_s,
                          :rental => rental_to_be_updated.attributes.merge(customer: rental_to_be_updated.customer.id).merge(apartment: rental_to_be_updated.apartment.id)}

            rental_from_db = Rental.find(rental_to_be_updated.id)
            expect(rental_from_db.start_date).to eq(Date.today + 1.month)
            expect(rental_from_db.end_date).to eq(Date.today + 1.year)
          end
        end
      end
    end

    describe '#confirm' do
      context 'when the entity does not exists' do
        it 'responds with 404' do
          put :confirm, {:id => 4.to_s}
          expect(response).to be_not_found
        end
      end

      context 'when the entity is found' do
        let(:rental_to_be_confirmed) { FactoryGirl.create :with_customer_and_apartment }

        context 'when the rental can not be confirmed' do
          it 'responds with 400' do
            rental_to_be_confirmed.confirm!
            put :confirm, {:id => rental_to_be_confirmed.id.to_s}
            expect(response).to be_bad_request
          end
        end

        context 'when the rental can be confirmed' do
          it 'responds with 200' do
            put :confirm, {:id => rental_to_be_confirmed.id.to_s}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            put :confirm, {:id => rental_to_be_confirmed.id.to_s}

            rental_from_db = Rental.find(rental_to_be_confirmed.id)
            expect(rental_from_db.confirmed?).to be true
          end
        end
      end
    end

    describe '#cancel' do
      context 'when the entity does not exists' do
        it 'responds with 404' do
          put :cancel, {:id => 4.to_s}
          expect(response).to be_not_found
        end
      end

      context 'when the entity is found' do
        let(:rental_to_be_canceled) { FactoryGirl.create :with_customer_and_apartment }

        context 'when the rental can not be canceled' do
          it 'responds with 400' do
            rental_to_be_canceled.cancel!
            put :cancel, {:id => rental_to_be_canceled.id.to_s}
            expect(response).to be_bad_request
          end
        end

        context 'when the rental can be canceled' do
          it 'responds with 200' do
            put :cancel, {:id => rental_to_be_canceled.id.to_s}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            put :cancel, {:id => rental_to_be_canceled.id.to_s}

            rental_from_db = Rental.find(rental_to_be_canceled.id)
            expect(rental_from_db.canceled?).to be true
          end
        end
      end
    end

  end
end
