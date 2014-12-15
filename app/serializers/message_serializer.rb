class MessageSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :created_at, :body, :latitude, :longitude
end
