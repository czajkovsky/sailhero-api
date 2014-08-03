class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :author

  def author
    user = object.user
    { id: user.id,
      email: user.email,
      name: user.name,
      surname: user.surname
    }
  end
end
