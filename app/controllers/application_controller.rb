class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def require_user
    redirect_to front_path if !current_user
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

end
