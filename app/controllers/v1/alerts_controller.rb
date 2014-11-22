module V1
  class AlertsController < RegionRestrictedController
    expose(:alerts) { Alert.active }
    expose(:alert, attributes: :permitted_params)

    def index
      render json: alerts
    end

    def show
      render json: alert
    end

    def create
      if alert.save
        alert.update_attributes(user: current_user)
        notify_users
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

    def notify_users
      current_user.region.users.each do |user|
        GCMPusher.new(data: { message: 'new alert' }, collapse_key: 'alert',
                      devices: user.devices.android.map(&:key)).call

      end
    end
  end
end
