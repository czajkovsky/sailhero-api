module V1
  module Map
    class PortsController < VersionController
      # doorkeeper_for :all
      expose(:ports) { ::Map::Port.all }

      def index
        render json: ports
      end
    end
  end
end
