class CountriesController < ActionController::API
  include ActionController::Serialization

  def index
    countries = Country.all
    if stale?(countries, last_modified: countries.last.updated_at)
      render json: countries, each_serializer: CountrySerializer
    end
  end
end