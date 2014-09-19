class QueueItem < ActiveRecord::Base

  belongs_to :user

  belongs_to :video

  validates_presence_of :position, :user, :video

  validates_uniqueness_of :user, scope: :video_id

  def rating
    review = Review.where(user: user, reviewable: video).first

    review.rating if review
  end

  # Defining these within the view is working outside in

  delegate :title, to: :video, prefix: :video
  #def video_title
  #  video.title
  #end

  def video_category
    category.name 
  end

  delegate :category, to: :video
  #def category
  #  video.category
  #end

end
