class BookingSerializer < ActiveModel::Serializer
  attributes %i(
    id book_day note status reason full_name email telephone
    check_in check_out created_at num_guest view_type amount price completed_at
  )
  belongs_to :user
  has_one :room_type
end
