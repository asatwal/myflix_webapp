class PagesController < ApplicationController

  def front
    redirect_to root_path if current_user
  end
end