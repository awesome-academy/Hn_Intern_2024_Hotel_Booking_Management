class AutoCheckBookingJob
  include Sidekiq::Job
  queue_as :default

  def perform booking_id
    booking = Booking.pending.find_by id: booking_id
    return unless booking

    booking.update status: :rejected,
                   reason: I18n.t("flash.request_not_approved")
    booking.send_mail_booking
  end
end
