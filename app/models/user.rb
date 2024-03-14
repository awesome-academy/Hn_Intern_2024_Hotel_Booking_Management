class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email

  validates :email, presence: true,
    length: {maximum: Settings.digits.digit_255},
    format: {with: Regexp.new(Settings.regexs.email, "i")},
    uniqueness: {case_sensitive: false}
  validates :full_name, presence: true
  validates :password, presence: true,
    length: {minimum: Settings.digits.digit_8},
    format: {with: Regexp.new(Settings.regexs.password), message: :format},
    allow_nil: true

  enum role: {user: 0, admin: 1}

  has_many :bookings, dependent: :destroy

  attr_accessor :remember_token

  def authenticated? attr, token
    digest = send "#{attr}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def remember_me
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private
  def downcase_email
    email.downcase!
  end
end
