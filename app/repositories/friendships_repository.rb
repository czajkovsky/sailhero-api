class FriendshipsRepository
  attr_accessor :user, :friendships

  def initialize(user)
    self.user = user
    self.friendships = []
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

  def all
    {
      accepted: accepted.serialize,
      pending: pending.serialize,
      sent: sent.serialize
    }
  end

  def serialize
    friendships.map { |f| FriendshipRepositorySerializer.new(user, f).to_json }
  end
end
