require 'rails_helper'

RSpec.describe CountriesController, type: :controller do

  describe 'Country API' do
    let(:token) { double :acceptable? => true }

    before do
      allow(controller).to receive_messages(:doorkeeper_token => token)
    end

    describe '#index' do
      login_user
      before :each do
        france = FactoryGirl.create :country, name: 'France'
        usa = FactoryGirl.create :country, name: 'USA'
        @expected_countries = [france, usa]

        get 'index'
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns the corresponding entities' do
        r = JSON.parse(response.body)

        expect(r['countries']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_countries, each_serializer: CountrySerializer).to_json))
      end
    end


    describe '#show' do
      login_user
      let!(:country_to_be_retrieved) { FactoryGirl.create :country }

      context 'when the resource is found' do
        before :each do
          get :show, {:id => country_to_be_retrieved.id.to_s}
        end
        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the corresponding entity' do
          r = JSON.parse(response.body)

          returned_country = r['country']
          expect(returned_country['id']).to eq(country_to_be_retrieved.id)
          expect(returned_country['name']).to eq(country_to_be_retrieved.name)
          expect(returned_country['iso']).to eq(country_to_be_retrieved.iso)
        end
      end

      context 'when the resource is not found' do
        it 'respond with 404' do
          get :show, {:id => 2000000.to_s}
          expect(response).to be_not_found
        end
      end
    end
  end


end
