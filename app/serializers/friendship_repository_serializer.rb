class FriendshipRepositorySerializer
  attr_accessor :user, :friendship

  def initialize(user, friendship)
    self.user = user
    self.friendship = friendship
  end

  def to_json(_ = {})
    {
      id: friendship.id,
      status: friendship.status,
      invited: (friendship.friend_id == user.id),
      friend: UserSerializer.new(friend).attributes
    }
  end

  private

  def friend
    friendship.user_id == user.id ? friendship.friend : friendship.user
  end
end
