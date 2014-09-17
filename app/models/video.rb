include ActionView::Helpers::NumberHelper

class Video < ActiveRecord::Base

  belongs_to :category

  # validates :title, presence: true
    
  # validates :description, presence: true

  # Use short hand instaed

  has_many :reviews,  -> { order 'created_at DESC'}, as: :reviewable

  validates_presence_of :title, :description

  def self.search_by_title(search_term)

    return [] if search_term.blank?

    where('title LIKE ?', "%#{search_term}%").order('created_at DESC')

  end

  def average_rating

    size = reviews.count

    return "None" if size == 0

    total = 0.0

    reviews.find_each {|r| total += r.rating}

    average = number_with_precision(total / size, precision: 1)

    "#{average}/5.0"
  end

end