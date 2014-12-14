class AlertRepository
  attr_accessor :user, :alert, :confirmation

  def initialize(user, id)
    self.user = user
    self.alert = Alert.find(id)
    process_confirmation
  end

  def vote(up)
    diff = confirmation ? update_confirmation(up) : create_confirmation(up)
    alert.update_attributes(credibility: alert.credibility += diff)
    alert.user_vote = (up ? 1 : -1)
    alert.archive! if alert.credibility < Alert::INACTIVE_TRESHOLD
  end

  private

  def process_confirmation
    self.confirmation = alert.confirmations.where(user_id: user.id).first
    alert.assign_user_vote(confirmation)
  end

  def create_confirmation(up)
    alert.confirmations.create(user_id: user.id, up: up)
    up ? 1 : -1
  end

  def update_confirmation(up)
    return 0 if confirmation.up == up
    confirmation.update_attributes(up: up)
    up ? 2 : -2
  end
end
