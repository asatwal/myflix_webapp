class VideosController < ApplicationController

  before_filter :require_user
  before_action :set_video, only: [:review, :show]


  def index
    @categories = Category.all
  end

  def category
     @category = Category.find(params[:id])
  end

  def show
    @review = Review.new
  end

  def search
    @search_term = params[:search_term]
    @videos = Video.search_by_title(@search_term)
  end

  def review

    new_review = Review.new(rating: review_params[:rating], comment: review_params[:comment], 
                            user: current_user, reviewable: @video)

    new_review.save ? @review = Review.new : @review = new_review

    render :show

  end

  def set_video
      @video = Video.find(params[:id])

  end

  def review_params
    params.require(:review).permit(:comment, :rating) 
  end

end
