class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    env['warden'].user
  end
  helper_method :current_user

  def signed_in?
    env['warden'].authenticated?
  end
  helper_method :signed_in?

  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?
end
