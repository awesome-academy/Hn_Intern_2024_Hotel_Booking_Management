# Update new
User.create!(full_name: "ADMIN", email: "admin@gmail.com", password: "Admin123@", password_confirmation: "Admin123@", role: 1, activated: 1)
User.create!(full_name: "test", email: "test@gmail.com", password: "Test123@", password_confirmation: "Test123@", role: 0, activated: 1)

facility_names = ["wifi", "bed", "bath", "pool", "air_conditioner", "tv", "iron", "sofa"]
facility_names.each do |name|
  Facility.create! name:
end
FACILITY_COUNT = facility_names.length

RoomType.create!(name: "single_room", price: 300000, num_of_bed: 1, size_of_bed: 1, description: Faker::Lorem.sentence(word_count: 20))
RoomType.create!(name: "twin_room", price: 400000, num_of_bed: 1, size_of_bed: 2, description: Faker::Lorem.sentence(word_count: 20))
RoomType.create!(name: "double_room", price: 500000, num_of_bed: 2, size_of_bed: 1, description: Faker::Lorem.sentence(word_count: 20))
RoomType.create!(name: "triple_room", price: 700000, num_of_bed: 3, size_of_bed: 1, description: Faker::Lorem.sentence(word_count: 20))

room_types = RoomType.all
n_room = 1
room_types.each do |t|
  (1..5).each do
    name = format("%d%02d", n_room / 5, n_room % 5)
    n_room += 1
    view_type = Faker::Base.rand_in_range(0, 3)
    Room.create!(name:, view_type:, room_type_id: t.id)
  end

  arr = Array.new
  n_facilities = Faker::Base.rand_in_range(3, 5)
  n_facilities.times do |i|
    begin
      facility = Facility.offset(rand(FACILITY_COUNT)).first
    end while arr.include? facility.id
    arr.append facility.id
    t.room_type_facilities.create!(facility_id: facility.id)
  end
end
