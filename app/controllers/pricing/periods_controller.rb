class Pricing::PeriodsController < ApplicationController
  include ActionController::Serialization

  def index
    periods = Pricing::Period.all
    render json: periods, each_serializer: Pricing::PeriodSerializer
  end

  def show
    period = Pricing::Period.find params[:id]
    if stale?(period, last_modified: period.updated_at)
      render json: period, serializer: Pricing::PeriodSerializer
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: 'Period does not exist'}, status: :not_found
  end
end
