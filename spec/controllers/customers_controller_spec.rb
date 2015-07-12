require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe 'Customers API' do

    describe '#index' do
      login_user
      let(:expected_customers) { Customer.all }

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

    describe '#show' do
      let(:expected_customer) { FactoryGirl.create :customer }

      context 'when the customer is found' do
        before :each do
          get :show, {:id => expected_customer.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the customer in JSON' do
          body = JSON.parse(response.body)
          customer = body['customer']

          expect(customer['id']).to eq(expected_customer.id)
          expect(customer['first_name']).to eq(expected_customer.first_name)
          expect(customer['last_name']).to eq(expected_customer.last_name)
          expect(customer['email']).to eq(expected_customer.email)
          expect(customer['phone']).to eq(expected_customer.phone)
          expect(customer['address'][0]['address']).to eq(expected_customer.address.address)
          expect(customer['address'][0]['address2']).to eq(expected_customer.address.address2)
          expect(customer['address'][0]['postal_code']).to eq(expected_customer.address.postal_code)
          expect(customer['address'][0]['city']).to eq(expected_customer.address.city)
          expect(customer['address'][0]['country'][0]['id']).to eq(expected_customer.address.country.id)
        end
      end

      context 'when the customer is not found' do
        it 'responds with 404' do
          get :show, {:id => 2}
          expect(response).to be_not_found
        end
      end
    end


    describe '#create' do
      login_user
      context 'when the submitted entity is not valid' do
        it 'responds with 400' do
          post :create, {:customer => {first_name: '', last_name: Faker::Name.last_name}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_customer) { FactoryGirl.build(:customer) }

        before :each do
          post :create, {:customer => FactoryGirl.attributes_for(:customer)
                                          .merge(address_attributes: FactoryGirl.build(:address).attributes)}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates a customer with the given attributes values' do
          id = JSON.parse(response.body)['customer']['id']


          created_customer = Customer.find id
          expect(created_customer.first_name).to eq(submitted_customer.first_name)
          expect(created_customer.last_name).to eq(submitted_customer.last_name)
          expect(created_customer.email).to eq(submitted_customer.email)
          expect(created_customer.phone).to eq(submitted_customer.phone)
          expect(created_customer.address).not_to be_nil
          expect(created_customer.address.id).not_to be_nil
          expect(created_customer.address.address).to eq(submitted_customer.address.address)
          expect(created_customer.address.address2).to eq(submitted_customer.address.address2)
          expect(created_customer.address.city).to eq(submitted_customer.address.city)
          expect(created_customer.address.postal_code).to eq(submitted_customer.address.postal_code)
          expect(created_customer.address.customer).to eq(created_customer)
        end
      end
    end

    describe '#update' do
      login_user
      context 'when the entity does not exists' do
        it 'responds with 404' do
          put :update, {:id => 4.to_s}
          expect(response).to be_not_found
        end
      end

      context 'when the entity is found' do
        let(:customer_to_be_updated) { FactoryGirl.create :customer }

        context 'when the submitted parameters are not valid' do
          it 'responds with 400' do
            customer_to_be_updated.first_name = ''
            put :update, {:id => customer_to_be_updated.id.to_s,
                          :customer => customer_to_be_updated.attributes}
            expect(response).to be_bad_request
          end
        end

        context 'when the submitted parameters are valid' do
          it 'responds with 200' do
            customer_to_be_updated.first_name = 'NewName'
            put :update, {:id => customer_to_be_updated.id.to_s,
                          :customer => customer_to_be_updated.attributes}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            customer_to_be_updated.first_name = 'NewName'
            put :update, {:id => customer_to_be_updated.id.to_s,
                          :customer => customer_to_be_updated.attributes}

            customer_from_db = Customer.find(customer_to_be_updated.id)
            expect(customer_from_db.first_name).to eq('NewName')
          end
        end

        context 'when the nested attributes are updated' do
          it 'responds with 200' do
            customer_to_be_updated.address.address2 = 'NewAddress2'
            put :update, {:id => customer_to_be_updated.id.to_s,
                          :customer => customer_to_be_updated.attributes
                                           .merge(address_attributes: customer_to_be_updated.address.attributes)}
            expect(response).to be_ok
          end

          it 'updates the nested entity' do
            customer_to_be_updated.address.address2 = 'NewAddress2'
            put :update, {:id => customer_to_be_updated.id.to_s,
                          :customer => customer_to_be_updated.attributes
                                           .merge(address_attributes: customer_to_be_updated.address.attributes)}

            customer_from_db = Customer.find(customer_to_be_updated.id)
            expect(customer_from_db.address.address2).to eq('NewAddress2')
            expect(customer_from_db.address.customer.id).to eq(customer_to_be_updated.id)
          end
        end

      end


    end
  end
end
