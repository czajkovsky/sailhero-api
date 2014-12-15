module V1
  class MessagesController < RegionRestrictedController
    before_filter :check_region, only: :show
    expose(:message, attributes: :permitted_params)

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
      render status: 460, nothing: true unless message.region == current_region
    end

    def messages
      region_id = current_region.id
      Message.where(region_id: region_id).page(params[:page]).per(params[:per])
    end

    def permitted_params
      params.require(:message).permit(:body)
    end

    def save_additional_data(user, region_id, latitude, longitude)
      message.update_attributes(user: user, region_id: region_id,
                                latitude: latitude, longitude: longitude)
    end
  end
end
