class User < ApplicationRecord
  # constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  # validations
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false },
                    confirmation: true
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  # relations

  # helpers
  has_secure_password

  # callbacks
  before_save do
    email.downcase!
  end
end
