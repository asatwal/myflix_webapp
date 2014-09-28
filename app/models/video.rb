include ActionView::Helpers::NumberHelper

class Video < ActiveRecord::Base

  belongs_to :category

  # validates :title, presence: true
    
  # validates :description, presence: true

  # Use short hand instaed

  has_many :reviews,  -> { order 'created_at DESC'}, as: :reviewable

  has_many :queue_items

  validates_presence_of :title, :description

  def self.search_by_title(search_term)

    return [] if search_term.blank?

    where('title LIKE ?', "%#{search_term}%").order('created_at DESC')

  end

  def average_rating

    total = 0.0
    size = 0

    reviews.find_each do |review|
      if review.rating
        total += review.rating 
        size += 1 # There is no pre or post increment operator in Ruby
      end
    end

    return "None" if size == 0

    average = number_with_precision(total / size, precision: 1)

    "#{average}/5.0"
  end

end