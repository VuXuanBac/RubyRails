class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: Settings.validation.name_len_max }
  validates :email, presence: true, length: { maximum: Settings.validation.email_len_max },
                    format: { with: Settings.validation.email_regex },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.validation.password_len_min }

  has_secure_password

  def remember
    self.remember_token = self.class.new_token
    update_attribute :remember_digest, self.class.digest(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  class << self
    # Returns the hash digest of the given string.
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
