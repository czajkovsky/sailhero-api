class Notifier
  attr_accessor :message, :key, :user

  def initialize(user)
    self.user = user
  end

  def notify_single_user
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: user.devices.android.map(&:key)).call
  end
end
