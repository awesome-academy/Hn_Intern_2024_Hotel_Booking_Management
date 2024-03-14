class Room < ApplicationRecord
  enum view_type: {pool: 0, balcony: 1, mountain: 2,
                   ocean: 3}
  enum room_type: {single_bedroom: 0, twin_bedroom: 1, double_bedroom: 2,
                   triple_bedroom: 3}

  has_many :room_facilities, dependent: :destroy
  has_many :facilities, through: :room_facilities, source: :facility
  has_many :bookings, dependent: :destroy

  # scope :latest, ->{order created_at: :desc}
  scope :desc_price, ->{order price: :desc}

  def available? check_in, check_out
    bookings.where("check_in <= ? AND check_out >= ?", check_out,
                   check_in).empty?
  end
end
