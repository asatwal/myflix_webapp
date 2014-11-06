class User < ActiveRecord::Base

  include Tokenable

  validates_presence_of :email_address, :full_name, :token

  validates_uniqueness_of :email_address

  has_secure_password validations: false

  validates :password, presence: true, on: :create

  validates :password, length: {minimum: 5}, unless: "password.blank?"

  validates :password, confirmation: true, unless: :password_fields_blank?

  has_many :queue_items, -> {order 'position ASC'}

  has_many :reviews, -> {order 'created_at DESC'}

  has_many :following_rels, class_name: 'Relationship', foreign_key: :follower_id

  has_many :leading_rels, class_name: 'Relationship', foreign_key: :leader_id

  has_many :invitations, foreign_key: :inviter_id

  def password_fields_blank?
    password.blank? && password_confirmation.blank?
  end


  def renumber_queue_items
    queue_items.each_with_index do |queue_item, index|
       queue_item.update_attributes(position: index + 1) 
    end
  end

  def follows? other_user
    following_rels.map(&:leader_id).include?(other_user.id)
  end

  def can_follow? other_user
    !(self == other_user || follows?(other_user))
  end

  def follow other_user
    following_rels.create(leader: other_user) if can_follow?other_user
  end

end