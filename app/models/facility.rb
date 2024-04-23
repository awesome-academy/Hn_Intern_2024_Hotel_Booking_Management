class Facility < ApplicationRecord
  has_many :room_type_facilities, dependent: :destroy
  has_many :room_types, through: :room_type_facilities, source: :room_type

  scope :asc_name, ->{order name: :asc}
end
