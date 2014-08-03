module V1
  class MessagesController < VersionController
    # doorkeeper_for :all
    expose(:messages)
    expose(:message, attributes: :permitted_params)

    def index
      render json: messages
    end

    def create
      if message.save
        message.update_attributes(user_id: current_user.id)
        render status: 201, json: message
      else
        render status: 422, json: { errors: message.errors }
      end
    end

    def permitted_params
      params.require(:message).permit(:body, :title)
    end
  end
end
