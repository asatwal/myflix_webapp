class VideosController < ApplicationController

  before_filter :require_user

  layout "application"

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def category
     @category = Category.find(params[:id])
  end

  def search
    @search_term = params[:search_term]
    @videos = Video.search_by_title(@search_term)
  end

end
