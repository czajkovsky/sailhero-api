class AlertConfirmationValidator
  attr_accessor :user, :alert, :status

  def initialize(user, alert)
    self.user = user
    self.alert = alert
    self.status = 200
  end

  def call
    alert_exists?
    valid? ? self_reporter? : (return self)
    valid? ? in_same_region? : (return self)
    self
  end

  def valid?
    status == 200
  end

  private

  def alert_exists?
    self.status = 404 if alert.nil? || !alert.active?
  end

  def self_reporter?
    self.status = 403 if alert.user_id == user.id
  end

  def in_same_region?
    self.status = 403 unless alert.region_id == user.region_id
  end
end
