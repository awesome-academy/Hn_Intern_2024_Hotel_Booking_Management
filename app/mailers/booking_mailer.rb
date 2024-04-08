class BookingMailer < ApplicationMailer
  extend RoomsHelper

  def confirm_booking booking
    @booking = booking

    mail to: booking.email, subject: t(".subject")
  end

  def reject_booking booking
    @booking = booking

    mail to: booking.email, subject: t(".subject")
  end
end
