class ReplySerializer < ActiveModel::Serializer
  attributes :id, :created_at, :body
end
