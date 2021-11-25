class ApplicationController < ActionController::Base
  NotAuthorized = Class.new(StandardError)
  rescue_from NotAuthorized, with: :user_not_authorized

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def manager_access?
    current_user&.role == 'manager' || current_user&.role == 'admin'
  end

  def check_authentication
    redirect_to login_path unless current_user
  end

  def check_authorization
    raise NotAuthorized unless manager_access?
  end

  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_back(fallback_location: root_path)
  end
end