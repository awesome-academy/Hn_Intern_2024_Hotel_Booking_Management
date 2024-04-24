FactoryBot.define do
  factory :room do
    sequence(:name) {|n| "0#{n}"}
    view_type {rand(0..3)}
    association :room_type, factory: :room_type
  end
end
