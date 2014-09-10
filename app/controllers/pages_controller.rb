class PagesController < ApplicationController

  layout "application"

  def front
    redirect_to root_path if current_user
  end

end