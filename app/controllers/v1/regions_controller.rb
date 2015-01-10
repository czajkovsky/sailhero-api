module V1
  class RegionsController < VersionController
    before_action :doorkeeper_authorize!
    expose(:regions)
    expose(:region)

    def index
      render json: regions
    end

    def select
      current_user.update_attributes(region_id: region.id)
      render json: region
    end
  end
end
