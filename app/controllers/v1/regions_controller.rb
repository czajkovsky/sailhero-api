module V1
  class RegionsController < VersionController
    doorkeeper_for :all
    expose(:regions)
    expose(:region)

    def index
      render json: regions
    end
  end
end
