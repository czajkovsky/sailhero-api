class AlertNotifier < Notifier
  def initialize(params = nil)
    self.key = 'alert'
    self.message = 'sync_alerts'
    super(params)
  end

  def call
    notify_all_users_in_region
  end
end
