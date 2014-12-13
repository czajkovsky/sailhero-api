class FriendshipRepositoryValidator
  attr_accessor :user, :potential_friend, :status

  def initialize(user, potential_friend)
    self.user = user
    self.potential_friend = potential_friend
    self.status = 200
  end

  def call
    friend_exists?
    valid? ? forever_alone? : (return self)
    valid? ? existing_friendship? : (return self)
    self
  end

  def valid?
    status == 200
  end

  private

  def friend_exists?
    self.status = 463 if potential_friend.nil?
  end

  def forever_alone?
    self.status = 462 if potential_friend == user
  end

  def existing_friendship?
    existing = Friendship.between_users(user.id, potential_friend.id)
    self.status = 403 unless existing.count.zero?
  end
end
