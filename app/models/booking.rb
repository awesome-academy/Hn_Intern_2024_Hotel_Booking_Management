class Booking < ApplicationRecord
  has_many :booked_rooms, dependent: :destroy

  belongs_to :user
  belongs_to :room_type

  validates :full_name, :check_in, :check_out, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.digits.digit_255},
    format: {with: Regexp.new(Settings.regexs.email, "i")}
  validates :telephone, presence: true,
    format: {with: Regexp.new(Settings.regexs.telephone)}
  validate :check_in_valid, :check_out_valid, on: :create
  validate :check_reason_presence, if: ->{rejected?}

  before_save :clear_reason_if_not_rejected

  enum status: {pending: 0, confirmed: 1, rejected: 2, completed: 3}

  scope :newest, ->{order book_day: :desc, check_in: :asc}

  def can_be_deleted?
    pending?
  end

  def send_mail_confirm
    if confirmed?
      BookingMailer.confirm_booking(self).deliver_now
    elsif rejected?
      BookingMailer.reject_booking(self).deliver_now
    end
  end

  def num_of_night
    ((check_out - check_in) / 86_400).to_i
  end

  def total_price
    num_of_night * amount * price
  end

  # config for ransack
  def self.ransackable_attributes _auth_object = nil
    %w(
      id full_name check_in check_out view_type
      room_type_id amount book_day status
    )
  end

  ransacker :book_day do
    Arel.sql("date(book_day)")
  end

  ransacker :check_in do
    Arel.sql("date(check_in)")
  end

  ransacker :check_out do
    Arel.sql("date(check_out)")
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

  def check_reason_presence
    return if reason.present?

    errors.add :reason, I18n.t("bookings.errors.require_reason")
  end

  def clear_reason_if_not_rejected
    self.reason = nil unless rejected?
  end
end
