module V1
  module Map
    class PortsController < VersionController
      doorkeeper_for :all
      expose(:ports)
      expose(:port)

      def index
        render json: ports
      end

      def show
        render json: port
      end

      def calculate
        render json: PortCostCalculator.new(current_user.yacht, port).serialize
      end
    end
  end
end
