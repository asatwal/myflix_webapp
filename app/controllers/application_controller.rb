
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def require_user
    redirect_to front_path if !current_user
  end

  def current_user
    # Use find_by rather than just find as it will return ActiveRecord::RecordNotFound if no rows that has to be handled
    user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

end

