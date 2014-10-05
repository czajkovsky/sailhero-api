module V1
  class HeartbeatController < VersionController
    doorkeeper_for :all
    skip_before_action :updated_current_position?

    def index
      status = updated_current_position? ? 200 : 427
      render status: status, nothing: true
    end
  end
end
