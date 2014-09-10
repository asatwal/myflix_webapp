class User < ActiveRecord::Base

  validates_presence_of :email_address, :full_name

  validates_uniqueness_of :email_address

  has_secure_password validations: false

  validates :password, presence: true, on: :create

  validates :password, length: {minimum: 5}, unless: "password.blank?"

  validates :password, confirmation: true, unless: :password_fields_blank?


  def password_fields_blank?
    password.blank? && password_confirmation.blank?
  end

end