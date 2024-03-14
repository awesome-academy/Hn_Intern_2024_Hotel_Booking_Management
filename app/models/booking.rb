class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :full_name, :check_in, :check_out, presence: true
  validates :email, presence: true,
    length: {maximum: Settings.digits.digit_255},
    format: {with: Regexp.new(Settings.regexs.email, "i")}
  validates :telephone, presence: true,
    format: {with: Regexp.new(Settings.regexs.telephone)}
  validate :check_in_valid
  validate :check_out_valid
  validate :date_valid

  enum status: {pending: 0, confirmed: 1, rejected: 2}

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
end
