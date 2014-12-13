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
end
