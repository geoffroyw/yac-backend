require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    describe 'abilities' do
      subject(:ability) { Ability.new(user) }
      let(:user) { nil }

      context 'when is member of the organization' do
        let(:user) {FactoryGirl.create(:user)}

        it{should be_able_to(:manage, Rental.new(organization: user.organization))}
        it{should be_able_to(:manage, Customer.new(organization: user.organization))}
        it{should be_able_to(:manage, Apartment::Apartment.new(organization: user.organization))}
        it{should be_able_to(:manage, Apartment::Equipment.new(organization: user.organization))}
        it{should be_able_to(:manage, Pricing::Price.new(organization: user.organization))}
        it{should be_able_to(:manage, Pricing::Period.new(organization: user.organization))}
        it{should be_able_to(:read, user.organization)}
      end

      context 'when is the admin of the organization' do
        let(:user) {FactoryGirl.create(:organization_admin_user)}

        it{should be_able_to(:manage, user.own_organization)}
      end
    end
  end

end