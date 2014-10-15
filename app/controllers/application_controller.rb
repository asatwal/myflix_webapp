
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :video_in_my_queue?, :rating_description

  def require_user
    redirect_to front_path if !current_user
  end

  def current_user
    # Use find_by rather than just find as it will return ActiveRecord::RecordNotFound if no rows that has to be handled
    @my_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def video_in_my_queue?(video)
    # !(video.queue_items.map {|item| item.user}.include?current_user) - Shorthand below
    video.queue_items.map(&:user).include?current_user if current_user
  end

  def rating_description rating

    rating ? "#{rating}/5" : "None"
  end

end

