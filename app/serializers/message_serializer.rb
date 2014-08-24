class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :author, :solved
  has_many :replies, embed: :ids, key: 'reply_ids', include: true

  def author
    user = object.user
    { id: user.id,
      email: user.email,
      name: user.name,
      surname: user.surname
    }
  end
end
