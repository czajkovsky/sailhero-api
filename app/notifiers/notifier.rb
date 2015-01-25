class Notifier
  attr_accessor :message, :key, :params

  def notify_single_user(user)
    androids = user.devices.android.map(&:key)
    notify_androids(androids)
  end

  def notify_all_users_in_region(region)
    androids = Device.where(user_id: region.users.pluck(:id)).android.map(&:key)
    notify_androids(androids)
  end

  private

  def notify_androids(androids)
    androids.delete(params[:caller].key) if params[:caller]
    GCMPusher.new(data: { message: message }, collapse_key: key,
                  devices: androids).call
  end
end
