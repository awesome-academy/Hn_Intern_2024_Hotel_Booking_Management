class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :full_name, :check_in, :check_out, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.digits.digit_255},
    format: {with: Regexp.new(Settings.regexs.email, "i")}
  validates :telephone, presence: true,
    format: {with: Regexp.new(Settings.regexs.telephone)}
  validate :check_in_valid, :check_out_valid, :date_valid, on: :create
  validate :check_reason_presence, if: ->{rejected?}

  before_save :clear_reason_if_not_rejected

  enum status: {pending: 0, confirmed: 1, rejected: 2}

  scope :newest, ->{order book_day: :desc, check_in: :asc}

  def can_be_deleted?
    pending?
  end

  private
  def check_in_valid
    return unless check_in && check_in < Time.zone.today

    errors.add :check_in, I18n.t("bookings.errors.can_not_in_past")
  end

  def check_out_valid
    return unless check_out && check_out < check_in

    errors.add :check_out, I18n.t("bookings.errors.check_out_invalid")
  end

  def date_valid
    return if room.available? check_in, check_out

    errors.add :room, I18n.t("bookings.errors.booked_room")
  end

  def check_reason_presence
    return if reason.present?

    errors.add :reason, I18n.t("bookings.errors.require_reason")
  end

  def clear_reason_if_not_rejected
    self.reason = nil unless rejected?
  end
end
