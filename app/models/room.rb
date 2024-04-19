class Room < ApplicationRecord
  enum view_type: {pool: 0, balcony: 1, mountain: 2,
                   ocean: 3}
  enum status: {active: 0, inactive: 1}

  has_many :booked_rooms, dependent: :destroy
  belongs_to :room_type

  scope :availabel, lambda {|sd, ed|
                      where.not(id: Booking.joins(:booked_rooms)
                          .where("check_in <= ? and check_out >= ?
                          and status = 1", ed.to_date, sd.to_date)
                          .pluck(:room_id))
                    }
  scope :filter_by_room_type_id, ->(t){where room_type_id: t}
  scope :filter_by_view_type, ->(t){where view_type: t}

  validates :name, presence: true, uniqueness: true

  def can_be_assigned? cin, cout
    active? && Booking.where("check_in <= ? and check_out >= ? and status = 1",
                             cout.to_date, cin.to_date)
                      .joins(:booked_rooms)
                      .where("booked_rooms.id = ?", id).empty?
  end

  def can_be_inactive?
    booked_rooms.joins(:booking).where(bookings: {status: [0, 1]}).empty?
  end

  def self.ransackable_attributes _auth_object = nil
    %w(id name view_type room_type_id created_at status)
  end

  ransacker :created_at do
    Arel.sql("date(created_at)")
  end

  def active
    update status: :active
  end

  def inactive
    update status: :inactive
  end
end
