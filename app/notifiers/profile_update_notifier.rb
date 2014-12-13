class ProfileUpdateNotifier < Notifier
  def initialize(params = {})
    self.message = 'profile'
    self.key = 'sync_profile'
    super(params)
  end

  def call
    notify_single_user
  end
end
