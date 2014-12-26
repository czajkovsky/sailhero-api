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
        calculator = PortCostCalculator.new(yacht: current_user.yacht,
                                            port: port).call
        render status: calculator.status, json: { port: calculator }
      end
    end
  end
end
