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

    describe '#show' do
      let(:expected_period) { FactoryGirl.create :period }

      context 'when the period is found' do
        before :each do
          get :show, {:id => expected_period.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the period in JSON' do
          body = JSON.parse(response.body)
          period = body['period']

          expect(period['id']).to eq(expected_period.id)
          expect(period['name']).to eq(expected_period.name)
          expect(period['start_date']).to eq(expected_period.start_date.to_s)
          expect(period['end_date']).to eq(expected_period.end_date.to_s)
        end
      end

      context 'when the period is not found' do
        it 'responds with 404' do
          get :show, {:id => 2}
          expect(response).to be_not_found
        end
      end
    end
  end
end
