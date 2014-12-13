class FriendshipNotifier < Notifier
  def initialize(params = {})
    self.message = 'friends'
    self.key = 'sync_friends'
    super(params)
  end

  def call
    notify_single_user
  end
end
