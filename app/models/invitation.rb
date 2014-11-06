class Invitation < ActiveRecord::Base

  include Tokenable

  validates_presence_of :email_address, :full_name, :message
  validates_uniqueness_of :email_address

  belongs_to :inviter, class_name: :User

end