class Notifier
  attr_accessor :message, :key, :params

  def notify_single_user(user)
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: user.devices.android.map(&:key)).call
  end

  def notify_all_users_in_region(region)
    android_devices = Device.where(user_id: region.users.pluck(:id)).android
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: android_devices.map(&:key)).call
  end
end
