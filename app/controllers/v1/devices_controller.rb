module V1
  class DevicesController < VersionController
    doorkeeper_for :all
    expose(:device, attributes: :permitted_params)
    before_action :device_exists?

    def create
      if device.save
        device.update_attributes(user_id: current_user.id,
                                 token_id: doorkeeper_token.id)
        render status: 201, json: device
      else
        render status: 422, json: { errors: device.errors }
      end
    end

    private

    def permitted_params
      params.require(:device).permit(:device_type, :name, :key)
    end

    def device_exists?
      user_device = Device.where(key: params[:device][:key]).first
      return unless user_device
      user_device.update_attributes(token_id: doorkeeper_token.id)
      render status: 201, json: user_device
    end
  end
end
