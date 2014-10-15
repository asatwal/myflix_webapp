class Relationship < ActiveRecord::Base

  belongs_to :follower, class_name: 'User'

  belongs_to :leader, class_name: 'User'
  
  validates_uniqueness_of :follower, scope: [:follower_id, :leader_id]
  validates_uniqueness_of :leader,   scope: [:follower_id, :leader_id]

end