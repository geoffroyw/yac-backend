require 'rails_helper'

RSpec.describe User::OrganizationsController, type: :controller do
  describe 'Organization API' do
    let(:token) { double :acceptable? => true }

    before do
      allow(controller).to receive_messages(:doorkeeper_token => token)
    end

    describe '#show' do
      login_user
      let(:expected_oragnization) { @user.organization }

      context 'when the organization is found' do
        before :each do
          get :show, {:id => expected_oragnization.id}, :format => :json
        end

        it 'responds with 200' do
          expect(response).to be_success
        end

        it 'returns the organization in JSON' do
          body = JSON.parse(response.body)
          organization = body['organization']

          expect(organization['id']).to eq(expected_oragnization.id)
          expect(organization['name']).to eq(expected_oragnization.name)
          expect(organization['users']).to eq(expected_oragnization.users.map { |u| u.id })
        end
      end

      context 'when the organization is not found' do
        it 'responds with 404' do
          get :show, {:id => 2}
          expect(response).to be_not_found
        end
      end

      context 'when the organization is not user organization' do
        let(:organization) { FactoryGirl.create :organization }
        it 'responds with 403' do
          get :show, {:id => organization.id}
          expect(response).to be_forbidden
        end
      end
    end

    describe '#create' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        @user = FactoryGirl.create(:user)
        @user.confirm
        sign_in @user
      end

      context 'when the submitted entity is not valid' do
        it 'responds with 400' do
          post :create, {:organization => {:name => ''}}
          expect(response).to be_bad_request
        end
      end

      context 'when the submitted entity is valid' do
        let(:submitted_organization) { FactoryGirl.build(:organization) }

        before :each do
          post :create, {:organization => submitted_organization.attributes}
        end

        it 'responds with 201' do
          expect(response).to be_created
        end

        it 'creates an organization with the given attributes values' do
          id = JSON.parse(response.body)['organization']['id']


          created_organization = Organization.find id
          expect(created_organization.name).to eq(submitted_organization.name)
          expect(created_organization.admin).to eq(@user)
          expect(created_organization.users).to include(@user)

        end
      end
    end

    describe '#update' do
      before(:each) do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        @user = FactoryGirl.create(:organization_admin_user)
        @user.confirm
        sign_in @user
      end
      context 'when the entity does not exists' do
        it 'responds with 404' do
          put :update, {:id => 4.to_s, :organization => @user.own_organization.attributes}
          expect(response).to be_not_found
        end
      end

      context 'when the organization is not user organization' do
        let(:organization) { FactoryGirl.create :organization }
        it 'responds with 403' do
          get :show, {:id => organization.id, :organization => organization.attributes}
          expect(response).to be_forbidden
        end
      end

      context 'when the entity is found' do
        let(:organization_to_be_updated) { @user.own_organization }

        context 'when the submitted parameters are not valid' do
          it 'responds with 400' do
            organization_to_be_updated.name = ''
            put :update, {:id => organization_to_be_updated.id.to_s,
                          :organization => organization_to_be_updated.attributes}
            expect(response).to be_bad_request
          end
        end

        context 'when the submitted parameters are valid' do
          it 'responds with 200' do
            organization_to_be_updated.name = 'NewName'
            put :update, {:id => organization_to_be_updated.id.to_s,
                          :organization => organization_to_be_updated.attributes}
            expect(response).to be_ok
          end

          it 'updates the entity' do
            organization_to_be_updated.name = 'NewName'
            put :update, {:id => organization_to_be_updated.id.to_s,
                          :organization => organization_to_be_updated.attributes}

            organization = Organization.find(organization_to_be_updated.id)
            expect(organization.name).to eq('NewName')
          end
        end
      end
    end
  end
end

