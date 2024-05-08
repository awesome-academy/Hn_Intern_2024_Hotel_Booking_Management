class UserSerializer < ActiveModel::Serializer
  attributes %i(id full_name email)
end
