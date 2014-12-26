module V1
  module Map
    class PortsController < RegionRestrictedController
      expose(:port)
      before_action :check_port, only: :show

      def index
        render json: current_region.ports
      end

      def show
        render json: port
      end

      def calculate
        calculator = PortCostCalculator.new(yacht: current_user.yacht,
                                            port: port).call
        render status: calculator.status, json: { port: calculator }
      end

      private

      def check_port
        render status: 404, nothing: true if port.region_id != current_region.id
      end
    end
  end
end
