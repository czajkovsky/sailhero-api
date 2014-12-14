module V1
  class AlertConfirmationsController < RegionRestrictedController
    before_action :allowed_to_vote?

    def create
      change_alert_status(true)
    end

    def destroy
      change_alert_status(false)
    end

    private

    def alert_repository
      AlertRepository.new(current_user, params[:id])
    end

    def allowed_to_vote?
      alert = alert_repository.alert
      v = AlertConfirmationValidator.new(current_user, alert).call
      render status: v.status, nothing: true unless v.valid?
    end

    def change_alert_status(up)
      alert_repository.vote(up)
      render status: 200, json: alert_repository.alert
    end
  end
end
