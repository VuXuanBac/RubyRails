class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: Settings.validation.name_len_max }
  validates :email, presence: true, length: { maximum: Settings.validation.email_len_max },
                    format: { with: Settings.email_regex },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.validation.password_len_min }

  has_secure_password
end
