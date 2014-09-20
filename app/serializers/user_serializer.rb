class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :created_at, :updated_at, :email
  has_one :yacht, embed: :id, include: true
end
