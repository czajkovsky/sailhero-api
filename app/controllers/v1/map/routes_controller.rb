module V1
  module Map
    class RoutesController < RegionRestrictedController
      before_action :check_region, except: :index
      expose(:route)
      def index
        render json: current_region.routes
      end

      def show
        render json: route
      end

      private

      def check_region
        invalid = route.nil? || current_region.id != route.region_id
        render nothing: true, status: 404 if invalid
      end
    end
  end
end
