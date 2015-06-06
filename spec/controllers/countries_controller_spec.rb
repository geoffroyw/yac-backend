require 'rails_helper'

RSpec.describe CountriesController, type: :controller do

  describe 'Country API' do
    it 'retrieves the list of countries' do

      france = FactoryGirl.create :country, name: 'France'
      usa = FactoryGirl.create :country, name: 'USA'

      expected_countries = [france, usa]

      get 'index'


      # test for the 200 status-code
      expect(response).to be_success

      r = JSON.parse(response.body)

      expect(r['countries']).to match_array(JSON.parse(ActiveModel::ArraySerializer.new(expected_countries, each_serializer: CountrySerializer).to_json))


    end
  end


end
