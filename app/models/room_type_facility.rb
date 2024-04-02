class RoomTypeFacility < ApplicationRecord
  belongs_to :facility
  belongs_to :room_type
end
