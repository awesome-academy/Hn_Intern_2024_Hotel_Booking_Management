FactoryBot.define do
  factory :booking do
    full_name {Faker::Name.name}
    email {Faker::Internet.email}
    association :room_type, factory: :room_type
    view_type {rand(0..3)}
    amount {rand(1..3)}
    num_guest {rand(1..3)}
    telephone {"0123123123"}
    price {rand(100000..500000)}
    check_in {Faker::Date.between(from: Date.today + 1.day, to: Date.today + 4.days)}
    check_out {Faker::Date.between(from: Date.today + 5.day, to: Date.today + 7.days)}
    association :user, factory: :user
    book_day {Faker::Date.between(from: Date.today - 4.days, to: Date.today - 1.day)}

    after(:create) do |booking, context|
      create_list(:booked_room, context.amount, booking:)
    end
  end

  factory :booked_room do
    association :booking
    association :room
  end
end
