require 'rails_helper'

RSpec.describe Apartment::ApartmentsController, type: :controller do
  describe 'Apartments API' do

    describe '#index' do
      before :each do
        @expected_apartments = []
        (0..3).each { @expected_apartments << FactoryGirl.create(:apartment_with_equipments) }
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
    let(:expected_apartment_with_equipments) { FactoryGirl.create :apartment_with_equipments }

    context 'when the apartment is found' do
      before :each do
        get :show, {:id => expected_apartment_with_equipments.id}
      end

      it 'responds with 200' do
        expect(response).to be_success
      end

      it 'returns the apartment in JSON' do
        body = JSON.parse(response.body)
        apartment = body['apartment']

        expect(apartment['id']).to eq(expected_apartment_with_equipments.id)
        expect(apartment['name']).to eq(expected_apartment_with_equipments.name)
        expect(apartment['capacity']).to eq(expected_apartment_with_equipments.capacity)
        expect(apartment['description']).to eq(expected_apartment_with_equipments.description)
        expect(apartment['equipments']).to eq(expected_apartment_with_equipments.equipments.map {|e| e.id} )
        expect(apartment['prices']).to eq(expected_apartment_with_equipments.prices.map {|p| p.id} )
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

    context 'when the submitted entity contains ids of equipments' do
      let(:equipment_1) {FactoryGirl.create(:equipment)}
      let(:equipment_2) {FactoryGirl.create(:equipment)}
      let(:submitted_apartment) { FactoryGirl.build(:apartment) }

      before :each do
        post :create, {:apartment => submitted_apartment.attributes.merge(equipments: [equipment_1.id, equipment_2.id])}
      end

      it 'responds with 201' do
        expect(response).to be_created
      end

      it 'creates an apartment with the given attributes values' do
        id = JSON.parse(response.body)['apartment']['id']

        created_apartment = Apartment::Apartment.includes(:equipments).find id
        expect(created_apartment.equipments.size).to eq(2)
      end

    end
  end

  describe '#update' do
    context 'when the entity does not exists' do
      it 'responds with 404' do
        put :update, {:id => 4.to_s, :apartment => FactoryGirl.attributes_for(:apartment)}
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

      context 'when the equipment is updated' do
        let(:apartment_to_be_updated) { FactoryGirl.create :apartment_with_equipments }
        it 'responds with 200' do
          apartment_to_be_updated.name = 'NewName'
          put :update, {:id => apartment_to_be_updated.id.to_s,
                        :apartment => apartment_to_be_updated.attributes}
          expect(response).to be_ok
        end

        it 'deletes all equipments if no one is passed' do
          apartment_to_be_updated.equipments = []
          put :update, {:id => apartment_to_be_updated.id.to_s,
                        :apartment => apartment_to_be_updated.attributes}

          apartment_from_db = Apartment::Apartment.includes(:equipments).find(apartment_to_be_updated.id)
          expect(apartment_from_db.equipments.size).to eq(0)
        end

        it 'updated the equipments if some are passed' do
          original_equipments_id = apartment_to_be_updated.equipments.each{|e| e.id}
          new_equipment = FactoryGirl.create(:equipment)
          equipments_id = [new_equipment.id]
          equipments_id << original_equipments_id
          put :update, {:id => apartment_to_be_updated.id.to_s,
                        :apartment => apartment_to_be_updated.attributes.merge(equipments: equipments_id.flatten)}

          apartment_from_db = Apartment::Apartment.includes(:equipments).find(apartment_to_be_updated.id)
          expect(apartment_from_db.equipments.size).to eq(original_equipments_id.size+1)
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
