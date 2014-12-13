class FriendshipRepository
  attr_accessor :user, :friendships

  def initialize(user)
    self.user = user
    self.friendships = []
  end

  def fetch(id)
    self.friendships = Friendship.find(id)
    self
  end

  def sent
    self.friendships = Friendship.where(status: 0, user_id: user.id)
    self
  end

  def accepted
    request = 'status = 1 and (user_id = ? or friend_id = ?)'
    self.friendships = Friendship.where(request, user.id, user.id)
    self
  end

  def pending
    self.friendships = Friendship.where(status: 0, friend_id: user.id)
    self
  end

  def between(friend)
    request = 'user_id = ? and friend_id = ? or user_id = ? and friend_id = ?'
    Friendship.where(request, user.id, friend.id, friend.id, user.id)
  end

  def serialize
    friendships.respond_to?('each') ? serialize_array : serialize_item
  end

  def serialize_array
    friendships.map { |f| FriendshipRepositorySerializer.new(user, f).to_json }
  end

  def serialize_item
    { friendship: FriendshipRepositorySerializer.new(user, friendships).to_json }
  end
end
