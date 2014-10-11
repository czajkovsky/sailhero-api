module V1
  class AlertsController < RegionRestrictedController
    expose(:alerts)
    expose(:alert, attributes: :permitted_params)

    def index
      render json: alerts
    end

    def create
      if alert.save
        render status: 201, json: alert
      else
        render status: 422, json: alert.errors
      end
    end

    private

    def permitted_params
      params.require(:alert).permit(:latitude, :longitude, :alert_type,
                                    :additional_info)
    end
  end
end
