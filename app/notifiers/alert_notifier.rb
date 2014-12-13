class AlertNotifier < Notifier
  def initialize(params = {})
    self.message = 'alert'
    self.key = 'sync_alerts'
    super(params)
  end

  def call
    notify_all_users_in_region
  end
end
