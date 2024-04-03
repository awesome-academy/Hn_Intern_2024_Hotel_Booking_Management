class Room < ApplicationRecord
  enum view_type: {pool: 0, balcony: 1, mountain: 2,
                   ocean: 3}

  has_many :booked_rooms, dependent: :destroy
  belongs_to :room_type

  scope :latest, ->{order created_at: :desc}
  scope :desc_price, ->{order price: :desc}
  scope :asc_price, ->{order price: :asc}
  scope :desc_name, ->{order name: :desc}
  scope :asc_name, ->{order name: :asc}
  scope :filter_by_room_type, lambda {|room_type|
                                where(room_type:) if room_type.present?
                              }
  scope :filter_by_view_type, lambda{|view_type|
                                where(view_type:) if view_type.present?
                              }
  scope :available_in_priod, lambda {|sd, ed|
                               if sd.present? && ed.present?
                                 where.not(
                                   id: Booking.where(
                                     "check_in <= ? and check_out >= ?", ed, sd
                                   ).select("room_id")
                                 )
                               end
                             }
end
