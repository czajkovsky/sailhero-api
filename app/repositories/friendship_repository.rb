class FriendshipRepository
  attr_accessor :user, :friendship

  def initialize(user)
    self.user = user
    self.friendship = nil
  end

  def fetch(id)
    self.friendship = Friendship.find(id)
    self
  end

  def serialize
    { friendship: FriendshipRepositorySerializer.new(user, friendship).to_json }
  end

  def allowed?
    user.id == friendship.friend_id || user.id == friendship.user_id
  end

  def accept!
    friendship.update_attributes(status: 1)
  end

  def destroy!
    friendship.destroy
  end

  def waiting_for_user?
    friendship.friend_id == user.id && friendship.pending?
  end
end
