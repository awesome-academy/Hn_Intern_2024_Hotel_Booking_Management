FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "test_#{n}@gmail.com"}
    full_name {Faker::Name.name}
    password {"Test123@"}
    password_confirmation {"Test123@"}
    confirmed_at {Time.zone.now}

    factory :user_with_bookings do
      transient do
        bookings_count {5}
      end

      bookings do
        Array.new(bookings_count) {association(:booking)}
      end
    end
  end
end
