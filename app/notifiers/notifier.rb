class Notifier
  attr_accessor :message, :key, :user

  def initialize(user)
    self.user = user
  end

  def notify_single_user
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: user.devices.android.map(&:key)).call
  end

  def notify_all_users_in_region
    devices = Device.where(user_id: User.first.region.users.pluck(:id))
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: devices.android.map(&:key)).call
  end
end
