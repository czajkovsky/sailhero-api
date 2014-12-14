class Notifier
  attr_accessor :message, :key, :params

  def notify_single_user(user)
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: user.devices.android.map(&:key)).call
  end

  def notify_all_users_in_region(region)
    devices = Device.where(user_id: region.users.pluck(:id))
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: devices.android.map(&:key)).call
  end
end
