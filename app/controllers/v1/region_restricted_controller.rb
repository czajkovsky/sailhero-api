module V1
  class RegionRestrictedController < VersionController
    doorkeeper_for :all
    before_action :check_region_presence

    def check_region_presence
      render nothing: true, status: 460 if current_user.region.nil?
    end
  end
end
