require 'rails_helper'

RSpec.describe Apartment::ApartmentsController, type: :controller do
  describe 'Apartments API' do

    describe '#index' do
      before :each do
        @expected_apartments = []
        (0..3).each { @expected_apartments << FactoryGirl.create(:apartment) }
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the customers in JSON' do
        body = JSON.parse(response.body)

        expect(body['apartments']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_apartments).to_json))

      end
    end
  end


end
