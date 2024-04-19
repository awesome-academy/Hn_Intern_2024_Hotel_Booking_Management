class ReviewsController < ApplicationController
  before_action :signed_in_user
  before_action :load_review, only: :update

  def create
    booking = Booking.find_by id: params.dig(:review, :booking_id)
    if booking.can_be_reviewed?
      @review = Review.new review_params
      if @review.save
        render_json t(".create_success"), :created
      else
        render_json t(".create_failed"), :unprocessable_entity
      end
    else
      render_json t(".cannot_review"), :unprocessable_entity
    end
  end

  def update
    if @review.update review_params
      render_json t(".update_success"), :ok
    else
      render_json t(".update_failed"), :unprocessable_entity
    end
  end

  private
  def review_params
    params.require(:review).permit :booking_id, :rating, :comment
  end

  def render_json msg, stt
    render json: {message: msg}, status: stt
  end

  def load_review
    @review = Review.find_by(booking_id: params.dig(:review, :booking_id))
    return if @review

    render_json t(".review_not_found"), :not_found
  end
end
