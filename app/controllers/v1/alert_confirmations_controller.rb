module V1
  class AlertConfirmationsController < RegionRestrictedController
    expose(:alert) { Alert.find_by_id(params[:id]) }
    before_filter :alert_exists?
    before_filter :reported_alert?

    def create
      change_alert_status(true)
    end

    def destroy
      change_alert_status(false)
    end

    private

    def change_alert_status(up)
      df = user_confirmation ? update_confirmation(up) : create_confirmation(up)
      alert.update_attributes(credibility: alert.credibility += df)
      alert.update_attributes(active: false) if alert.credibility < 0
      render status: 200, json: alert
    end

    def create_confirmation(up)
      alert.confirmations.create(user_id: current_user.id, up: up)
      up ? 1 : -1
    end

    def update_confirmation(up)
      return 0 if user_confirmation.up == up
      user_confirmation.update_attributes(up: up)
      up ? 2 : -2
    end

    def alert_exists?
      render nothing: true, status: 404 if alert.nil?
    end

    def reported_alert?
      render nothing: true, status: 403 if alert.user == current_user
    end

    def user_confirmation
      confirmations = alert.confirmations.where(user_id: current_user.id)
      confirmations.present? ? confirmations.first : nil
    end
  end
end
