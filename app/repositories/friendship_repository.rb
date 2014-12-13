class FriendshipRepository
  attr_accessor :user, :friend, :friendship

  def initialize(user, id)
    self.user = user
    self.friendship = Friendship.find(id)
    self.friend = assign_friend
  end

  def assign_friend
    friendship.user_id == user.id ? friendship.friend : friendship.user
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
