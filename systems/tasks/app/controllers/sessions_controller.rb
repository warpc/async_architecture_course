class SessionsController < ApplicationController
  # If you're using a strategy that POSTs during callback, you'll need to skip the authenticity token check for the callback action only.
  skip_before_action :verify_authenticity_token, only: :create

  def new
  end

  def create
    @user = User.find_or_create_from_auth_hash(params[:provider], auth_hash)
    session[:user_id]= @user.id
    redirect_to '/'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end