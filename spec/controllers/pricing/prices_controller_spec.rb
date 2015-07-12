require 'rails_helper'

RSpec.describe Pricing::PricesController, type: :controller do
  describe 'Prices API' do
    let(:token) { double :acceptable? => true }

    before do
      allow(controller).to receive_messages(:doorkeeper_token => token)
    end

    describe '#index' do
      login_user
      before :each do
        @expected_prices = []
        (0..3).each { @expected_prices << FactoryGirl.create(:price) }
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the apartments in JSON' do
        body = JSON.parse(response.body)

        expect(body['prices']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_prices).to_json))
      end
    end

    describe '#show' do
      login_user
      let(:expected_price) { FactoryGirl.create :price }

      context 'when the price is found' do
        before :each do
          get :show, {:id => expected_price.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the price in JSON' do
          body = JSON.parse(response.body)
          price = body['price']

          expect(price['id']).to eq(expected_price.id)
          expect(price['number_of_night']).to eq(expected_price.number_of_night)
          expect(price['amount_cents']).to eq(expected_price.amount_cents)
          expect(price['amount_currency']).to eq(expected_price.amount_currency)
          expect(price['period'][0]['id']).to eq(expected_price.period.id)
          expect(price['period'][0]['name']).to eq(expected_price.period.name)
          expect(price['period'][0]['start_date']).to eq(expected_price.period.start_date.to_s)
          expect(price['period'][0]['end_date']).to eq(expected_price.period.end_date.to_s)
        end
      end

      context 'when the price is not found' do
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
          post :create, {:price => {:number_of_night => -5}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_price) { FactoryGirl.build(:price) }

        before :each do
          post :create, {:price => submitted_price.attributes}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates a Price with the given attributes values' do
          id = JSON.parse(response.body)['price']['id']


          created_price = Pricing::Price.find id
          expect(created_price.number_of_night).to eq(submitted_price.number_of_night)
          expect(created_price.amount_cents).to eq(submitted_price.amount_cents)
          expect(created_price.period.id).to eq(submitted_price.period.id)
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
        let(:price_to_be_updated) { FactoryGirl.create :price }

        context 'when the submitted parameters are not valid' do
          it 'responds with 400' do
            price_to_be_updated.number_of_night = -150
            put :update, {:id => price_to_be_updated.id.to_s,
                          :price => price_to_be_updated.attributes}
            expect(response).to be_bad_request
          end
        end

        context 'when the submitted parameters are valid' do
          it 'responds with 200' do
            price_to_be_updated.number_of_night = 150
            put :update, {:id => price_to_be_updated.id.to_s,
                          :price => price_to_be_updated.attributes}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            price_to_be_updated.number_of_night = 150
            put :update, {:id => price_to_be_updated.id.to_s,
                          :price => price_to_be_updated.attributes}

            price_from_db = Pricing::Price.find(price_to_be_updated.id)
            expect(price_from_db.number_of_night).to eq(150)
          end
        end
      end
    end
  end
end
