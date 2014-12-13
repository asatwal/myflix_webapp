class AdminsController < ApplicationController

  before_action :require_user, :require_admin

  private

  def require_admin
    unless current_user.admin?
      flash[:danger] = 'You are not authorised to perform that action.'
      redirect_to root_path 
    end
  end

end