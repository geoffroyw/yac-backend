require 'rails_helper'

RSpec.describe Apartment::EquipmentsController, type: :controller do

  describe 'Equipments API' do
    let(:token) { double :acceptable? => true }

    before do
      allow(controller).to receive_messages(:doorkeeper_token => token)
    end

    describe '#index' do
      login_user
      before :each do
        @expected_equipments = []
        (0..3).each { @expected_equipments << FactoryGirl.create(:equipment) }
        get :index
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns all the apartments in JSON' do
        body = JSON.parse(response.body)

        expect(body['equipments']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(@expected_equipments).to_json))

      end
    end

    describe '#show' do
      login_user
      let(:expected_equipment) { FactoryGirl.create :equipment }

      context 'when the apartment is found' do
        before :each do
          get :show, {:id => expected_equipment.id}
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the apartment in JSON' do
          body = JSON.parse(response.body)
          apartment = body['equipment']

          expect(apartment['id']).to eq(expected_equipment.id)
          expect(apartment['name']).to eq(expected_equipment.name)
          expect(apartment['description']).to eq(expected_equipment.description)
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
      login_user
      context 'when the submitted entity is not valid' do
        it 'responds with 400' do
          post :create, {:equipment => {:description => Faker::Lorem.paragraph}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_equipment) { FactoryGirl.build(:equipment) }

        before :each do
          post :create, {:equipment => FactoryGirl.attributes_for(:equipment)}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates an apartment with the given attributes values' do
          id = JSON.parse(response.body)['equipment']['id']


          created_equipment = Apartment::Equipment.find id
          expect(created_equipment.name).to eq(submitted_equipment.name)
          expect(created_equipment.description).to eq(submitted_equipment.description)

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
        let(:equipment_to_be_updated) { FactoryGirl.create :equipment }

        context 'when the submitted parameters are not valid' do
          it 'responds with 400' do
            equipment_to_be_updated.name = ''
            put :update, {:id => equipment_to_be_updated.id.to_s,
                          :equipment => equipment_to_be_updated.attributes}
            expect(response).to be_bad_request
          end
        end

        context 'when the submitted parameters are valid' do
          it 'responds with 200' do
            equipment_to_be_updated.name = 'NewName'
            put :update, {:id => equipment_to_be_updated.id.to_s,
                          :equipment => equipment_to_be_updated.attributes}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            equipment_to_be_updated.name = 'NewName'
            put :update, {:id => equipment_to_be_updated.id.to_s,
                          :equipment => equipment_to_be_updated.attributes}

            equipment_from_db = Apartment::Equipment.find(equipment_to_be_updated.id)
            expect(equipment_from_db.name).to eq('NewName')
          end
        end
      end
    end

    describe '#delete' do
      login_user
      context 'when the entity does not exists' do
        it 'responds with 404' do
          delete :destroy, {:id => 4.to_s}
          expect(response).to be_not_found
        end
      end

      context 'when the entity is found' do
        let(:equipment_to_be_deleted) { FactoryGirl.create :equipment }

        context 'when the entity is not deleted' do
          it 'responds with 204' do
            delete :destroy, {:id => equipment_to_be_deleted.id.to_s}
            expect(response.code).to eq('204')
            expect { Apartment::Equipment.find equipment_to_be_deleted.id }.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'when the entity is already deleted' do
          it 'responds with 404' do
            equipment_to_be_deleted.delete
            delete :destroy, {:id => equipment_to_be_deleted.id.to_s}
            expect(response).to be_not_found
          end
        end
      end
    end

  end
end
