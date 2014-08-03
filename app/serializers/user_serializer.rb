class UserSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :email
end
