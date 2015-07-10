require 'rails_helper'

RSpec.describe Pricing::PeriodsController, type: :controller do

  describe 'Period API' do

    describe '#index' do
      before :each do
        @expected_periods = []
        (0..3).each { @expected_periods << FactoryGirl.create(:period) }
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the apartments in JSON' do
        body = JSON.parse(response.body)

        expect(body['periods']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_periods).to_json))

      end
    end
  end
end
