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
        pc = PortCostCalculator.new(yacht: current_user.yacht, port: port).call
        render json: pc.to_json
      end
    end
  end
end
