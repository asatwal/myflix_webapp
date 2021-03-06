module Tokenable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_token, on: :create
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end