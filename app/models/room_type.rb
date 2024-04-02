class RoomType < ApplicationRecord
  has_many :room_type_facilities, dependent: :destroy
end
