class Review < ActiveRecord::Base

  belongs_to :user

  belongs_to :reviewable, polymorphic: true

  # validates_uniqueness_of :creator, scope: [:reviewable_id, :reviewable_type]

  validates_presence_of :rating, :comment
end

