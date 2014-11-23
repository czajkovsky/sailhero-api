class FriendshipSerializer < ActiveModel::Serializer
  attributes :id, :status, :user, :friend, :created_at, :updated_at

  def user
    side(object.user_id)
  end

  def friend
    side(object.friend_id)
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
