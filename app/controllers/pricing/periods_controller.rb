class Pricing::PeriodsController < ApplicationController
  include ActionController::Serialization

  load_and_authorize_resource class: Pricing::Period

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'Period does not exist'}, status: :not_found
  end

  def index
    render json: @periods, each_serializer: Pricing::PeriodSerializer
  end

  def show
    if stale?(@period, last_modified: @period.updated_at)
      render json: @period, serializer: Pricing::PeriodSerializer
    end
  end

  def create
    period = Pricing::Period.new period_params
    period.organization = current_user.organization
    if period.save
      render json: period, serializer: Pricing::PeriodSerializer, status: :created
    else
      render json: {errors: period.errors}, status: :bad_request
    end
  end

  def update
    if @period.update period_params
      render json: @period, serializer: Pricing::PeriodSerializer, status: :ok
    else
      render json: {errors: @period.errors}, status: :bad_request
    end
  end

  private
  def period_params
    params.require(:period).permit(:name, :start_date, :end_date)
  end
end
