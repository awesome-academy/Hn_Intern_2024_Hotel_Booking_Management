FactoryBot.define do
  factory :room_type do
    sequence(:name) {|n| "room_type_#{n}"}
    price {rand(100000..500000)}

    after(:create) do |room_type, context|
      create_list(:room, 5, room_type:)
    end

    after(:create) do |room_type, context|
      create_list(:room_type_facility, 3, room_type:)
    end
  end

  factory :room_type_facility do
    association :room_type
    association :facility
  end
end
