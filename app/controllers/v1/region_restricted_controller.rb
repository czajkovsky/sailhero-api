module V1
  class RegionRestrictedController < VersionController
    doorkeeper_for :all
    before_action :check_region_presence

    def check_region_presence
      render nothing: true, status: 460 if current_user.region.nil?
    end

    def notify_all_users_in_region(message, key)
      current_user.region.users.each do |user|
        GCMPusher.new(data: { message: message }, collapse_key: key,
                      devices: user.devices.android.map(&:key)).call
      end
    end
  end
end
