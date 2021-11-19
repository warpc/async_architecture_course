class ApplicationController < ActionController::Base
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def manager_access?
    current_user && current_user.manager_access?
  end
end
