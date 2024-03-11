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
  private
  def downcase_email
    email.downcase!
  end
end
