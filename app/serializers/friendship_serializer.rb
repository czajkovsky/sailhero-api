class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :status, :invitor_id, :friend, :created_at, :updated_at

  def friend
    object.invited ? side(object.user_id) : side(object.friend_id)
  end

  def invitor_id
    object.user_id
  end

  def side(id)
    user = User.find(id)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      surname: user.surname
    }
  end
end
