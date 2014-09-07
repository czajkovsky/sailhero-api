module V1
  module Map
    class PortsController < VersionController
      # doorkeeper_for :all
      expose(:ports)
      expose(:port)

      def index
        render json: ports
      end

      def show
        render json: port
      end
    end
  end
end
