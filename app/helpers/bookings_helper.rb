module BookingsHelper
  def show_tag_status status
    case status
    when "pending"
      content_tag(:span, t(status), class: "badge bg-warning rounded-pill fs-5")
    when "confirmed"
      content_tag(:span, t(status), class: "badge bg-success rounded-pill fs-5")
    when "rejected"
      content_tag(:span, t(status), class: "badge bg-danger rounded-pill fs-5")
    when "completed"
      content_tag(:span, t(status), class: "badge bg-info rounded-pill fs-5")
    end
  end

  def status_options
    Booking.statuses.map{|k, v| [t(k), v]}
  end
end
