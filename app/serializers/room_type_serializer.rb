class RoomTypeSerializer < ActiveModel::Serializer
  attributes %i(id name num_of_bed size_of_bed status)
end
