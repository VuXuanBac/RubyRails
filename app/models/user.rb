class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: Settings.validation.name_len_max }
  validates :email, presence: true, length: { maximum: Settings.validation.email_len_max },
                    format: { with: Settings.validation.email_regex },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.validation.password_len_min }
  validate :validate_not_old_password, on: :update

  scope :sort_list, -> { order(name: :asc, email: :asc) }
  scope :on_activated, -> { where(activated: true) }

  has_secure_password

  def remember
    self.remember_token = self.class.new_token
    update_attribute :remember_digest, self.class.digest(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    match_digest? digest, token
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < Settings.validation.pwd_expires_long.hours.ago
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = self.class.new_token
    update_columns reset_digest: self.class.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.for_user id
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

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = self.class.new_token
    self.activation_digest = self.class.digest activation_token
  end

  def match_digest? digest, token
    BCrypt::Password.new(digest).is_password? token
  end

  # Validate not reuse old password
  def validate_not_old_password
    if match_digest? password_digest_was, password
      errors.add :password, I18n.t("errors.old_pwd")
    end
  end
end
