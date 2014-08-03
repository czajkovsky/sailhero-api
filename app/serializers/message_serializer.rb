class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :author, :solved

  def author
    user = object.user
    { id: user.id,
      email: user.email,
      name: user.name,
      surname: user.surname
    }
  end
end
