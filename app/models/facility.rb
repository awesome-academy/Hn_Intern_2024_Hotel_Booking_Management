class Facility < ApplicationRecord
  has_many :room_facilities, dependent: :destroy
  has_many :rooms, through: :room_facilities, source: :room
end
