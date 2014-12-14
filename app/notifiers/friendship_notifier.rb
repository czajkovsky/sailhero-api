class FriendshipNotifier < Notifier
  def initialize(params = {})
    self.params = params
    self.message = 'friends'
    self.key = 'sync_friends'
  end

  def call
    notify_single_user(params[:user])
  end
end
