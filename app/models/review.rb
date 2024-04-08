class Review < ApplicationRecord
  belongs_to :booking
  has_one :user, through: :booking, source: :user

  enum :status, {pending: 0, confirmed: 1}

  before_save :strip_comment

  private
  def strip_comment
    comment.strip!
  end
end
