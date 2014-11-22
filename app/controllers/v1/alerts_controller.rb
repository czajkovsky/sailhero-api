module V1
  class AlertsController < RegionRestrictedController
    expose(:alerts) { current_user.region.alerts.active }
    expose(:alert, attributes: :permitted_params)

    def index
      render json: alerts
    end

    def show
      render json: alert
    end

    def create
      if alert.save
        alert.update_attributes(user: current_user, region: current_user.region)
        notify_all_users_in_region('sync_alerts', 'alert')
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
