module V1
  class RegionsController < VersionController
    expose(:regions)
    expose(:region)

    def index
      render json: regions
    end
  end
end
