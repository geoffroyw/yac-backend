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

  def create
    period = Pricing::Period.new period_params
    if period.save
      render json: period, serializer: Pricing::PeriodSerializer, status: :created
    else
      render json: {errors: period.errors}, status: :bad_request
    end
  end

  private
  def period_params
    params.require(:period).permit(:name, :start_date, :end_date)
  end
end
