facility_names = ["wifi", "bed", "bath", "pool", "air_conditioner", "tv", "iron", "sofa"]
facility_names.each do |name|
  Facility.create! name:
end
ROOM_COUNT = 20
FACILITY_COUNT = Facility.count
ROOM_COUNT.times do |n|
  name = format("%d%02d", n / 5, n % 5 + 1)
  price = Faker::Number.between(from: 50, to: 100).to_f
  description = Faker::Lorem.sentence word_count: 10
  view_type = Faker::Base.rand_in_range(0, 3)
  room_type = Faker::Base.rand_in_range(0, 3)
  room = Room.create!(name:, price:, description:, view_type:, room_type:)
  # check availabel facility
  s = Array.new
  5.times do
    begin
      facility = Facility.offset(rand(FACILITY_COUNT)).first
    end while s.include? facility.id
    s.append facility.id

    quantity = Faker::Base.rand_in_range(1, 2)
    room.room_facilities.create! facility:, quantity:
  end
end

User.create!(full_name: "ADMIN", email: "admin@gmail.com", password: "Admin123@", password_confirmation: "Admin123@", role: 1)
