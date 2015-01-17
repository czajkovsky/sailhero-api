module V1
  class AlertsController < RegionRestrictedController
    expose(:alerts_repository) { AlertsRepository.new(current_user) }

    def index
      render json: alerts_repository.alerts
    end

    def show
      alert_repository = AlertRepository.new(current_user, params[:id])
      render json: alert_repository.alert
    end

    def create
      alert = Alert.new(permitted_params)
      alert.update_attributes(user: current_user, region: current_user.region)
      if alert.save
        alert.user_vote = 0
        AlertNotifier.new(region: alert.region).call
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
