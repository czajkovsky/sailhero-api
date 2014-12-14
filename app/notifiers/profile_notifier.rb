class ProfileNotifier < Notifier
  def initialize(params = {})
    self.message = 'profile'
    self.key = 'sync_profile'
    self.params = params
  end

  def call
    notify_single_user(params[:user])
  end
end
