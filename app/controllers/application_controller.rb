class ApplicationController < ActionController::API
  before_filter :authenticate_user!
  before_action :doorkeeper_authorize!
end
