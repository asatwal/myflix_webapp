class Review < ActiveRecord::Base

  belongs_to :creator,  foreign_key: 'user_id', class_name: 'User'

  belongs_to :reviewable, polymorphic: true

  # validates_uniqueness_of :creator, scope: [:reviewable_id, :reviewable_type]

  validates_presence_of :comment, :rating

end

