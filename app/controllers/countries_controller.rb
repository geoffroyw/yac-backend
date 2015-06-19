class CountriesController < ActionController::API
  include ActionController::Serialization

  def index
    countries = Country.all
    if stale?(countries, last_modified: countries.last.updated_at)
      render json: countries, each_serializer: CountrySerializer
    end
  end

  def show
    country = Country.find params[:id]
    if stale?(country, last_modified: country.updated_at)
      render json: country, serializer: CountrySerializer
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Country does not exist' }, status: :not_found
  end
end