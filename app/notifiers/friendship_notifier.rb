class FriendshipNotifier < Notifier
  def initialize(params = nil)
    self.key = 'friends'
    self.message = 'sync_friends'
    super(params)
  end

  def call
    notify_single_user
  end
end
