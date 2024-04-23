class RoomType < ApplicationRecord
  after_update :change_active_rooms, if: :saved_change_to_status?

  has_many :room_type_facilities, dependent: :destroy
  has_many :facilities, through: :room_type_facilities, source: :facility
  has_many :rooms, dependent: :nullify
  has_many_attached :images do |attrachable|
    attrachable.variant :display, resize_to_limit: Settings.image_size.s_240x240
  end

  scope :latest, ->{order created_at: :desc}
  scope :desc_price, ->{order price: :desc}
  scope :asc_price, ->{order price: :asc}
  scope :filter_by_view_type, ->(v){having("view_type = ?", v) if v.present?}
  scope :filter_by_room_type, ->(t){having("name = ?", t) if t.present?}
  scope :filter_by_amount, ->(n){having("room_count >= ?", n) if n.present?}
  scope :availabel_rooms, lambda {|sd = nil, ed = nil|
    if sd.present? && ed.present?
      joins(:rooms)
        .where("rooms.id NOT IN (?)",
               Room.joins(booked_rooms: :booking)
                 .where(
                   "bookings.check_in <= ?
                    and bookings.check_out >= ? and bookings.status = 1
                    and rooms.status = 0", ed, sd
                 )
                 .select("booked_rooms.room_id"))
        .group("room_types.id, rooms.view_type")
        .select(
          "room_types.*,
          rooms.view_type,
          count(rooms.view_type) as room_count"
        )
    else
      joins(:rooms)
        .group("room_types.id", "rooms.view_type")
        .select(
          "room_types.*,
          count(rooms.view_type) as room_count, rooms.view_type"
        )
    end
  }
  enum :size_of_bed, {single: 1, double: 2}
  enum :status, {active: 0, inactive: 1}

  def self.ransackable_attributes _auth_object = nil
    %w(id name price num_of_bed size_of_bed status)
  end

  def active
    update status: :active
  end

  def inactive
    update status: :inactive
  end

  def can_be_inactive?
    rooms.joins(booked_rooms: :booking).where(bookings: {status: [0, 1]}).empty?
  end

  private
  def change_active_rooms
    rooms.update_all status:
  end
end
