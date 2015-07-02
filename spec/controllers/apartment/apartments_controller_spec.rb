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

      it 'returns all the apartments in JSON' do
        body = JSON.parse(response.body)

        expect(body['apartments']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_apartments).to_json))

      end
    end
  end

  describe '#show' do
    let(:expected_apartment) { FactoryGirl.create :apartment }

    context 'when the apartment is found' do
      before :each do
        get :show, {:id => expected_apartment.id}
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns the apartment in JSON' do
        body = JSON.parse(response.body)
        apartment = body['apartment']

        expect(apartment['id']).to eq(expected_apartment.id)
        expect(apartment['name']).to eq(expected_apartment.name)
        expect(apartment['capacity']).to eq(expected_apartment.capacity)
        expect(apartment['description']).to eq(expected_apartment.description)
      end
    end

    context 'when the apartment is not found' do
      it 'responds with 404' do
        get :show, {:id => 2}
        expect(response).to be_not_found
      end
    end
  end

  describe '#create' do
    context 'when the submitted entity is not valid' do
      it 'responds with 400' do
        post :create, {:apartment => {:name => Faker::Commerce.product_name, :capacity => -1, :description => Faker::Lorem.paragraphs}}
        expect(response).to be_bad_request
      end
    end

    context 'when the submitted entity is valid' do
      let(:submitted_apartment) { FactoryGirl.build(:apartment) }

      before :each do
        post :create, {:apartment => FactoryGirl.attributes_for(:apartment)}
      end

      it 'responds with 201' do
        expect(response).to be_created
      end

      it 'creates an apartment with the given attributes values' do
        id = JSON.parse(response.body)['apartment']['id']


        created_apartment = Apartment::Apartment.find id
        expect(created_apartment.name).to eq(submitted_apartment.name)
        expect(created_apartment.capacity).to eq(submitted_apartment.capacity)
        expect(created_apartment.description).to eq(submitted_apartment.description)

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
      let(:apartment_to_be_updated) { FactoryGirl.create :apartment }

      context 'when the submitted parameters are not valid' do
        it 'responds with 400' do
          apartment_to_be_updated.name = ''
          put :update, {:id => apartment_to_be_updated.id.to_s,
                        :apartment => apartment_to_be_updated.attributes}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted parameters are valid' do
        it 'responds with 200' do
          apartment_to_be_updated.name = 'NewName'
          put :update, {:id => apartment_to_be_updated.id.to_s,
                        :apartment => apartment_to_be_updated.attributes}
          expect(response).to be_ok
        end

        it 'updates the entity' do
          apartment_to_be_updated.name = 'NewName'
          put :update, {:id => apartment_to_be_updated.id.to_s,
                        :apartment => apartment_to_be_updated.attributes}

          apartment_from_db = Apartment::Apartment.find(apartment_to_be_updated.id)
          expect(apartment_from_db.name).to eq('NewName')
        end
      end
    end
  end

  describe '#delete' do
    context 'when the entity does not exists' do
      it 'responds with 404' do
        delete :destroy, {:id => 4.to_s}
        expect(response).to be_not_found
      end
    end

    context 'when the entity is found' do
      let(:apartment_to_be_deleted) { FactoryGirl.create :apartment }

      context 'when the entity is not deleted' do
        it 'responds with 204' do
          delete :destroy, {:id => apartment_to_be_deleted.id.to_s}
          expect(response.code).to eq('204')
          expect {Apartment::Apartment.find apartment_to_be_deleted.id}.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'when the entity is already deleted' do
        it 'responds with 404' do
          apartment_to_be_deleted.delete
          delete :destroy, {:id => apartment_to_be_deleted.id.to_s}
          expect(response).to be_not_found
        end
      end
    end
  end


end
