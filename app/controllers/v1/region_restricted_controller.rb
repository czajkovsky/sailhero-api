module V1
  class RegionRestrictedController < VersionController
    before_action :doorkeeper_authorize!
    before_action :check_region_presence

    def check_region_presence
      render nothing: true, status: 460 if current_user.region.nil?
    end
  end
end
