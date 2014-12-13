class AlertsRepository
  attr_accessor :user, :alerts

  def initialize(user)
    self.user = user
    self.alerts = user.region.alerts.includes(:confirmations).active
    process!
  end

  def process!
    alerts.each do |alert|
      alert.assign_user_vote(alert.confirmations.where(user_id: user.id).first)
    end
  end
end
