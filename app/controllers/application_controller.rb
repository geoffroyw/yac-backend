class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  before_filter :authenticate_user!
  before_action :doorkeeper_authorize!

  rescue_from CanCan::AccessDenied do |exception|
    render nothing: true, status: :forbidden
  end
end
