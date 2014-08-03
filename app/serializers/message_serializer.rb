class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
end
