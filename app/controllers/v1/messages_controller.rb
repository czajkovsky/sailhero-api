module V1
  class MessagesController < RegionRestrictedController
    expose(:message, attributes: :permitted_params)
    expose(:messages)

    def index
      render json: messages
    end

    def create
      if message.save
        render status: 201, json: message
      else
        render status: 422, json: { errors: message.errors }
      end
    end

    def show
      render json: message
    end

    private

    def permitted_params
      params.require(:message).permit(:body, :latitude, :longitude)
    end
  end
end
