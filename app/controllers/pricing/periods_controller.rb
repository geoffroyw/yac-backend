class Pricing::PeriodsController < ApplicationController
  include ActionController::Serialization

  def index
    periods = Pricing::Period.all
    render json: periods, each_serializer: Pricing::PeriodSerializer
  end
end
