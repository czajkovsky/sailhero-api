module V1
  module Map
    class RoutesController < RegionRestrictedController
      def index
        render json: current_region.routes
      end
    end
  end
end
