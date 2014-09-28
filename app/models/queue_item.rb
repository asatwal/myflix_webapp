class QueueItem < ActiveRecord::Base

  belongs_to :user

  belongs_to :video

  validates_presence_of :position, :user, :video

  validates_uniqueness_of :user, scope: :video_id

  validates_numericality_of :position, only_integer: true

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(user: user, reviewable: video, rating: new_rating)

      new_review.save(validate: false)

    end
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

  def self.update_queue_items(queue_item_data, queue_user)


    ActiveRecord::Base.transaction do

      # iterate over all input parameters and save to database
      queue_item_data.each do |item|

        queue_item = QueueItem.find(item[:id])

        if queue_item && (queue_item.user == queue_user)
          queue_item.update_attributes!(position: item[:position], rating: item[:rating] )
        end
      end
    end
  end

  def review
    @review ||= Review.where(user: user, reviewable: video).first
  end

end
