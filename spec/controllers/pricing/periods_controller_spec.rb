require 'rails_helper'

RSpec.describe Pricing::PeriodsController, type: :controller do

  describe 'Period API' do

    describe '#index' do
      login_user
      login_user
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
      login_user
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

    describe '#create' do
      login_user
      context 'when the submitted entity is not valid' do
        it 'responds with 400' do
          post :create, {:period => {:name => ''}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_period) { FactoryGirl.build(:period) }

        before :each do
          post :create, {:period => submitted_period.attributes}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates an apartment with the given attributes values' do
          id = JSON.parse(response.body)['period']['id']


          created_period = Pricing::Period.find id
          expect(created_period.name).to eq(submitted_period.name)
          expect(created_period.start_date).to eq(submitted_period.start_date)
          expect(created_period.end_date).to eq(submitted_period.end_date)
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
        let(:period_to_be_updated) { FactoryGirl.create :period }

        context 'when the submitted parameters are not valid' do
          it 'responds with 400' do
            period_to_be_updated.name = ''
            put :update, {:id => period_to_be_updated.id.to_s,
                          :period => period_to_be_updated.attributes}
            expect(response).to be_bad_request
          end
        end

        context 'when the submitted parameters are valid' do
          it 'responds with 200' do
            period_to_be_updated.name = 'NewName'
            put :update, {:id => period_to_be_updated.id.to_s,
                          :period => period_to_be_updated.attributes}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            period_to_be_updated.name = 'NewName'
            put :update, {:id => period_to_be_updated.id.to_s,
                          :period => period_to_be_updated.attributes}

            period_from_db = Pricing::Period.find(period_to_be_updated.id)
            expect(period_from_db.name).to eq('NewName')
          end
        end
      end
    end
  end
end
