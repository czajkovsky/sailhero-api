module V1
  class MessagesController < RegionRestrictedController
    expose(:message, attributes: :permitted_params)
    expose(:messages)

    before_filter :check_region, only: [:index, :show]

    def index
      render json: messages
    end

    def create
      if message.save
        save_additional_data(current_user, current_user.region_id,
                             params[:latitude], params[:longitude])
        render status: 201, json: message
      else
        render status: 422, json: { errors: message.errors }
      end
    end

    def show
      render json: message
    end

    private

    def check_region
      render status: 460, nothing: true if message.region != current_user.region
    end

    def permitted_params
      params.require(:message).permit(:body, :latitude, :longitude)
    end

    def save_additional_data(user, region_id, latitude, longitude)
      message.update_attributes(user: user, region_id: region_id,
                                latitude: latitude, longitude: longitude)
    end
  end
end
