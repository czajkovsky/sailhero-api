class FriendshipRepositoryValidator
  attr_accessor :user, :friendship, :status

  def initialize(repository)
    self.user = repository.user
    self.friendship = repository.friendship
  end
end
